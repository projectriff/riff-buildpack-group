# Contributor's guide: Testing an Unreleased Invoker, Buildpack or Builder

This guide explains how to test an unreleased riff invoker and/or riff buildpack and/or riff builder.

If you only need to deploy the latest builder (i.e. `master`), directly start from [this section](#updating-the-builder).

## La Vida Local

This method is the fastest way to externally validate an invoker.
It does not _necessarily_ requires a riff install on a working Kubernetes cluster.
However, the downside is the corresponding tooling must be installed on your machine as a lot happens locally:

 - Golang SDK for the [Command Invoker](https://github.com/projectriff/command-function-invoker/) and the [Streaming Adapter](https://github.com/projectriff/streaming-http-adapter)
 - JDK and Maven for the [Java Invoker](https://github.com/projectriff/java-function-invoker) and the local bindings generator of the [Java Processor](https://github.com/projectriff/streaming-processor)
 - Node and NPM for the [Node Invoker](https://github.com/projectriff/node-function-invoker)
 
PROTIP: before starting, make sure all the changes to test have been pulled locally.

This documentation assumes that all projects are cloned in `~/workspace`.

### Command Invoker

Validating the command invoker is super straightforward as it only supports request-reply functions 
(where input = standard input, output = standard output).

 1. build it as documented in the repository
 1. export `FUNCTION_URI` pointing to a local binary
 1. execute the invoker binary
 1. 💰 profit
 
### Streaming Invokers

While using the Streaming Adapter is not required if the validation is about streaming functions only, 
this documentation always involve the adapter to reflect what actually happens on clusters.

#### Starting the Node Invoker

In one terminal, start the adapter and the invoker (logs will appear there):

```shell
 $ cd ~/workspace/streaming-http-adapter
 $ FUNCTION_URI=/path/to/function.js NODE_DEBUG='riff' ./streaming-http-adapter node ~/workspace/node-function-invoker/server.js
```

#### Starting the Java Invoker

In one terminal, start the adapter and the invoker:

```shell
 $ cd ~/workspace/streaming-http-adapter
 $ mvn --file ~/workspace/java-function-invoker clean package
 $ ./streaming-http-adapter java -jar ~/workspace/java-function-invoker/target/java-function-invoker-*.jar --spring.cloud.function.location=/path/to/function.jar --spring.cloud.function.function-class=function.class.Name
```

When testing a Spring Boot function instead of a plain old `java.util.function.Function` (a.k.a. POJUFF? 🤔), 
replace `--spring.cloud.function.function-class=function.class.Name` with `spring.cloud.function.definition=functionBeanName`.

#### Sending a Request / Getting a Reply

In another terminal, send a HTTP request against `localhost:8080` and wait for the response. For instance:

```shell
curl http://localhost:8080 -H'Content-Type:application/json' -d'0' -H'Accept:text/plain' -v
```

#### Publishing inputs / Observing outputs

For that part, you will need [a working riff installation](https://projectriff.io/docs), **including the streaming runtime**.

Once that's done, create the required gateways and streams for the function to test with the riff CLI.
For instance:

```shell
 $ riff streaming kafka-gateway create franz --bootstrap-servers kafka.kafka:9092 --tail
 $ riff streaming stream create words --content-type text/plain --gateway franz
 $ riff streaming stream create numbers --content-type application/json --gateway franz
 $ riff streaming stream create repeated --content-type text/plain --gateway franz
```

Now, clone the [Java Processor](https://github.com/projectriff/streaming-processor) and run its local bindings generator
in order to locally replicate the binding structure generated on the cluster by the commands above:

```shell
 $ cd ~/workspace/streaming-processor
# topic declaration order possibly matters if the targetted function resolves arguments by order.
 $ ./src/etc/local_bindings.sh \
    --default-gateway franz-gateway-4v8fj:6565 \
    --input-topic words \
    --input-topic numbers \
    --output-topic repeated --accept text/plain
Please configure CNB_BINDINGS envvar to point to /var/folders/t5/04x3n9gx2c1b74vrljr4sn6h0000gq/T/local-bindings5922978358290298314 when running Processor
``` 

Note the generated path, as we will reuse it when configuring the streaming processor.
You can also point to an existing directory with `--base-directory`.

> Just run `./src/etc/local_bindings.sh` to see the available configuration options.

Install and run [`kubefwd`](https://kubefwd.com/) in **another** terminal so that `franz-gateway-4v8fj:6565` is 
forwarded to the actual in-cluster Liiklus instance. In this example:

```shell
 $ sudo kubefwd svc franz-gateway-4v8fj
```

The invoker must have started, please refer to previous sections otherwise.

Once the invoker is started, start the processor **in a separate terminal** with the appropriate configuration. 
In this example (notice the `CNB_BINDINGS` value from the `local_bindings.sh` execution):

```shell
 $ INPUT_NAMES='words,numbers' \
    INPUT_START_OFFSETS='latest,latest' \
    OUTPUT_NAMES='repeated' \
    FUNCTION='localhost:8081' \
    GROUP='somehow-irrelevant' \
    CNB_BINDINGS='/var/folders/t5/04x3n9gx2c1b74vrljr4sn6h0000gq/T/local-bindings5922978358290298314' \
    mvn exec:java -Dstart-class="io.projectriff.processor.Processor"
```

Finally, clone the [`stream-client-go` fork](https://github.com/fbiville/stream-client-go/tree/stream_publisher):

```shell
 $ git clone https://github.com/fbiville/stream-client-go/ -b stream_publisher && cd stream-client-go
 $ make stream-publish
```

Run in separate terminals (1 terminal per input stream, basically):

```shell
 $ ./stream-publish -gateway franz-gateway-4v8fj -topic words -accept text/plain -content-type text/plain
   Write payload and <ENTER>, <CTRL-C> to stop
```

```shell
 $ ./stream-publish -gateway franz-gateway-4v8fj -topic numbers -accept application/json -content-type application/json
   Write payload and <ENTER>, <CTRL-C> to stop
```

## Life on K18s

First, pick the buildpack(s) corresponding to the invoker(s) that needs to be validated.
Update said buildpack(s) to point to the invoker(s).
Then, create a local builder image with the locally modified buildpack(s).
Finally, update your riff-system configuration to consume that image and profit!

### Updating Buildpacks

#### Command Function Buildpack

 1. Create an archive of the command invoker (`cd ~/workspace/command-function-invoker; make release`)
 2. Clone the command function buildpack [repository](https://github.com/projectriff/command-function-buildpack/)
 3. Edit [`buildpack.toml`](https://github.com/projectriff/command-function-buildpack/blob/e69f4edaab35d80bc37c152f4070a5cb5c30538e/buildpack.toml#L35) to point it to the local archive created at step 1 (`file:///path/to/command/invoker.tgz`) and update the checksum accordingly
 4. Run `make build`
 
#### Node Function Buildpack

 1. Create an archive of the Node invoker (`cd /path/to/node/invoker; npm pack`)
 2. Clone the Node function buildpack [repository](https://github.com/projectriff/node-function-buildpack/)
 3. Edit [`buildpack.toml`](https://github.com/projectriff/node-function-buildpack/blob/c93bb2ed0f8add3b4026f084487d3c3180cfa5a6/buildpack.toml#L35) to point it to the local archive created at step 1 (`file:///path/to/node/invoker.tgz`) and update the checksum accordingly
 4. Run `make build`

#### Java Function Buildpack

 1. Create an archive of the Java invoker (`cd /path/to/java/invoker; mvn package`)
 2. Clone the Java function buildpack [repository](https://github.com/projectriff/java-function-buildpack/)
 3. Edit [`buildpack.toml`](https://github.com/projectriff/java-function-buildpack/blob/7ee5574089ad230d16bcf1ddd71909a1d5e22b60/buildpack.toml#L35) to point it to the local archive created at step 1 (`file:///path/to/node/invoker.tgz`) and update the checksum accordingly
 4. Run `make build`
 
### [Updating the Builder](#updating-the-builder)

 1. Clone the Builder [repository](https://github.com/projectriff/builder)
 2. Run `make build-dev`, this will automatically pick up all local buildpacks 💅
Alternatively, run `make build` if you only need the latest builder without specific changes to the buildpacks or invokers.
 3. If you don't have the permission to push the resulting builder image (i.e. `projectriff/builder`), 
alias it to something that works, e.g.: `docker tag projectriff/builder fbiville/builder` 
and push it (`docker push fbiville/builder`)
 
### Updating riff-system configuration

Now the only thing left to is:

```shell
kubectl edit clusterbuilder/riff-function
```

And change the `riff-function` entry.
The next `riff function create` execution should pick up the right builder 🎉