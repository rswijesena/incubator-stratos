/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.apache.stratos.cartridge.agent.phase.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.stratos.cartridge.agent.event.publisher.CartridgeAgentEventPublisher;
import org.apache.stratos.cartridge.agent.executor.ExtensionExecutor;
import org.apache.stratos.cartridge.agent.phase.Phase;

/**
 * Starting phase of Cartridge Agent. From instance (VM) started state to
 * process (PHP cartridge case, apache2 process) started state.
 */
public class StartingPhase extends Phase {
	
	private static final Log log = LogFactory.getLog(StartingPhase.class);

	public StartingPhase() {
		super(StartingPhase.class.getName());
	}
	
	public StartingPhase(String id) {
		super(id);
	}

	@Override
	public void execute() {
		
		log.info("Currently Executing Phase: "+super.getId());
		
		// execute all the extensions of this phase in order.
		for (ExtensionExecutor extensionExecutor : super.getExtensions()) {
			extensionExecutor.execute();
		}

		// Publish instance activated event
        CartridgeAgentEventPublisher.publishInstanceActivatedEvent();
        
        log.info("Finished Executing Phase: "+super.getId());
	}

}
