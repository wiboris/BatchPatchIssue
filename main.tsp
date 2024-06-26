import "@typespec/rest";
import "@typespec/versioning";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "@azure-tools/typespec-client-generator-core";

using TypeSpec.Reflection;
using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.Core.Traits;
using Azure.ClientGenerator.Core;

@service({
    title: "Azure Batch",
})
@versioned(Azure.Batch.Versions)
@doc("Azure Batch provides Cloud-scale job scheduling and compute management.")
namespace Azure.Batch;

@doc("The Azure Batch service version.")
enum Versions {
    @doc("API Version 2023-05-01.17.0")
    @useDependency(Azure.Core.Versions.v1_0_Preview_2)
    `2023-05-01.17.0`,
}

// operations
@patch
op PatchOperation<TResource, TResponse> is RpcOperation<
  BatchClientRequestHeaders & MinimalMetadata & TResource,
  BatchResponseHeaders & TResponse,
  NoFilter,
  BatchError
>;

#suppress "@azure-tools/typespec-azure-core/no-response-body" "Legacy behavior"
@put
op ReplaceOperation<TResource, TResponse> is RpcOperation<
  BatchClientRequestHeaders & MinimalMetadata & TResource,
  BatchResponseHeaders & TResponse,
  NoFilter,
  BatchError
>;

// Templates
alias NoFilter = {};
alias MinimalMetadata = {
  @doc("Type of content")
  @header("content-type")
  contentType: "application/json; odata=minimalmetadata";
};

// interfaces
@client({
  name: "BatchClient",
  service: Azure.Batch,
})
interface Batch {
  @summary("Updates the properties of the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}")
  patchJobSchedule is PatchOperation<
    {
      @doc("The ID of the Job Schedule to update.")
      @path
      jobScheduleId: string;

      @doc("The options to use for updating the Job Schedule.")
      @body
      jobSchedule: BatchJobScheduleUpdateContent;
    },
    RequestSuccesResponseHeaders
  >;

  @summary("Updates the properties of the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}")
  replaceJobSchedule is ReplaceOperation<
    {
      @doc("The ID of the Job Schedule to update.")
      @path
      jobScheduleId: string;

      @doc("A Job Schedule with updated properties")
      @body
      jobSchedule: BatchJobSchedule;
    },
    RequestSuccesResponseHeaders
  >;
}

// models

@doc("""
Parameters for updating an Azure Batch Job Schedule.
""")
model BatchJobScheduleUpdateContent {
  @doc("A string that uniquely identifies the schedule within the Account.")
  id?: string;
}


@doc("""
A Job Schedule that allows recurring Jobs by specifying when to run Jobs and a
specification used to create each Job.
""")
model BatchJobSchedule {
  @doc("A string that uniquely identifies the schedule within the Account.")
  @visibility("read")
  id?: string;
}

@doc("An error response received from the Azure Batch service.")
@error
model BatchError {
    @doc("An identifier for the error. Codes are invariant and are intended to be consumed programmatically.")
    code: string;

    @doc("A message describing the error, intended to be suitable for display in a user interface.")
    message?: ErrorMessage;

    @doc("A collection of key-value pairs containing additional details about the error.")
    values?: BatchErrorDetail[];
}

@doc("An error message received in an Azure Batch error response.")
model ErrorMessage {
    @doc("The language code of the error message.")
    lang?: string;

    @doc("The text of the message.")
    value?: string;
}

@doc("An item of additional information included in an Azure Batch error response.")
model BatchErrorDetail {
    @doc("An identifier specifying the meaning of the Value property.")
    key?: string;

    @doc("The additional information included with the error response.")
    value?: string;
}

// headers

alias RequestSuccesResponseHeaders = {
  @doc("A process exit code.")
  @statusCode
  code: "200";

  ...DataServiceResponseHeaders;
};

alias DataServiceResponseHeaders = {
  @header("DataServiceId")
  @doc("The OData ID of the resource to which the request applied.")
  dataServiceId: string;
};

#suppress "@azure-tools/typespec-azure-core/casing-style" "The names of Model types must use camelCase"
@doc("The parameters for a widget status request")
model BatchClientRequestHeaders {
  @doc("""
The maximum number of items to return in the response. A maximum of 1000
applications can be returned.
""")
  @query
  timeOutInSeconds?: int32 = 30;

  @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
  @header
  `client-request-id`?: string;

  @doc("Whether the server should return the client-request-id in the response.")
  @header
  `return-client-request-id`?: boolean = false;

  @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
  @header
  @encode(DateTimeKnownEncoding.rfc7231)
  `ocp-date`?: utcDateTime;
}

@doc("Common header values for pool requests")
model BatchPoolHeaders {
  @doc("The ID of the Pool to get.")
  @path
  poolId: string;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "The names of Model types must use camelCase"
@doc("Client related response header values")
model BatchResponseHeaders {
    @doc("The client-request-id provided by the client during the request. This will be returned only if the return-client-request-id parameter was set to true.")
    @header
    `client-request-id`?: string;

    @doc("A unique identifier for the request that was made to the Batch service. If a request is consistently failing and you have verified that the request is properly formulated, you may use this value to report the error to Microsoft. In your report, include the value of this request ID, the approximate time that the request was made, the Batch Account against which the request was made, and the region that Account resides in.")
    @header
    `request-id`?: string;

    @doc("The ETag HTTP response header. This is an opaque string. You can use it to detect whether the resource has changed between requests. In particular, you can pass the ETag to one of the If-Modified-Since, If-Unmodified-Since, If-Match or If-None-Match headers.")
    @header
    etag?: string;

    @doc("The time at which the resource was last modified.")
    @header
    @encode(DateTimeKnownEncoding.rfc7231)
    `Last-Modified`?: utcDateTime;
}
