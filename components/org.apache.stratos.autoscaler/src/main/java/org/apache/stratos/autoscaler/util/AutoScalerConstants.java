/*
 * Licensed to the Apache Software Foundation (ASF) under one 
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY 
 * KIND, either express or implied.  See the License for the 
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.stratos.autoscaler.util;

public final class AutoScalerConstants {

    /**
     * Constant values for Auto Scaler
     */
    public static final String ID_ELEMENT = "id";
    public static final String PARTITION_ELEMENT = "partition";
    public static final String PARTITIONS_ELEMENT = "partitions";
    public static final String PROPERTY_ELEMENT = "property";
    public static final String PROPERTY_NAME_ATTR= "name";
    public static final String PROPERTY_VALUE_ATTR = "value";
    
    /**
	 * Persistence
	 */
	public static final String AUTOSCALER_RESOURCE = "/autoscaler";
	public static final String PARTITION_RESOURCE = "/partitions";
	public static final String AS_POLICY_RESOURCE = "/policies/autoscalingPolicies";
	public static final String DEPLOYMENT_POLICY_RESOURCE = "/policies/deploymentPolicies";
       
}
