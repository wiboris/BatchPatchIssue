// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// <auto-generated/>

#nullable disable

using System.Collections.Generic;
using System.Linq;

namespace Azure.Compute.Batch
{
    /// <summary> Model factory for models. </summary>
    public static partial class ComputeBatchModelFactory
    {
        /// <summary> Initializes a new instance of <see cref="Batch.BatchJobSchedule"/>. </summary>
        /// <param name="id"> A string that uniquely identifies the schedule within the Account. </param>
        /// <returns> A new <see cref="Batch.BatchJobSchedule"/> instance for mocking. </returns>
        public static BatchJobSchedule BatchJobSchedule(string id = null)
        {
            return new BatchJobSchedule(id, serializedAdditionalRawData: null);
        }
    }
}