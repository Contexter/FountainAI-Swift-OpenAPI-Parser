// Auto-generated from OpenAPIYAMLContainer.swift
// This file contains the OpenAPI YAML definition for Ensemble_Service

import Foundation

struct Ensemble_Service {
    /// The OpenAPI YAML definition
    static let yaml: String = """
openapi: 3.1.0\ninfo:\n  title: FountainAI Ensemble Service\n  description: This OpenAPI specification defines the endpoints for the FountainAI Ensemble Service, which acts as an intermediary between users, the OpenAI Assistant, and FountainAI services managed via Kong. All FountainAI services are routed and orchestrated through Kong API Gateway, providing centralized management and control. Kong's rerouting capabilities are leveraged to distribute user input dynamically across multiple services, enabling flexible interaction flows and the implementation of the mediator design pattern for efficient delegation and aggregation of responses.\n  version: 1.1.0\nservers:\n  - url: https://localhost\n    description: Local server for testing and development\npaths:\n  /gui/overview:\n    get:\n      summary: Retrieve overview data\n      description: Retrieves overview data for services, routes, consumers, and plugins from Kong.\n      operationId: retrieveGuiOverview\n      responses:\n        '200':\n          description: Overview data retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  services:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        id:\n                          type: string\n                          description: The ID of the Kong service\n                        name:\n                          type: string\n                          description: The name of the Kong service\n                  routes:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        id:\n                          type: string\n                          description: The ID of the Kong route\n                        paths:\n                          type: array\n                          items:\n                            type: string\n                          description: The paths configured for the route\n                  consumers:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        id:\n                          type: string\n                          description: The ID of the Kong consumer\n                        username:\n                          type: string\n                          description: The username of the Kong consumer\n                  plugins:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        id:\n                          type: string\n                          description: The ID of the Kong plugin\n                        name:\n                          type: string\n                          description: The name of the plugin\n        '500':\n          description: Internal server error\n\n  /gui/metrics:\n    get:\n      summary: Retrieve metrics data\n      description: Retrieves metrics for services and consumers in Kong.\n      operationId: retrieveGuiMetrics\n      responses:\n        '200':\n          description: Metrics retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  service_metrics:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        service_id:\n                          type: string\n                          description: The ID of the Kong service\n                        status:\n                          type: string\n                          description: The status of the service (e.g., active, degraded, down)\n                  consumer_metrics:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        consumer_id:\n                          type: string\n                          description: The ID of the consumer\n                        requests_handled:\n                          type: integer\n                          description: Number of requests handled by this consumer\n        '500':\n          description: Internal server error\n\n  /kong/consumers:\n    get:\n      summary: Retrieve list of Kong consumers\n      description: Retrieves the list of consumers configured in the Kong API Gateway.\n      operationId: listKongConsumers\n      responses:\n        '200':\n          description: Kong consumers retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the Kong consumer\n                    username:\n                      type: string\n                      description: The username of the Kong consumer\n        '500':\n          description: Internal server error\n    post:\n      summary: Create a new Kong consumer\n      description: Creates a new consumer in the Kong API Gateway.\n      operationId: createKongConsumer\n      requestBody:\n        description: Details of the Kong consumer to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                username:\n                  type: string\n                  description: The username of the consumer\n                custom_id:\n                  type: string\n                  description: A custom identifier for the consumer\n      responses:\n        '201':\n          description: Kong consumer created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created Kong consumer\n        '400':\n          description: Bad request - Invalid consumer data provided\n        '500':\n          description: Internal server error\n\n  /kong/consumers/{consumerId}:\n    patch:\n      summary: Update an existing Kong consumer\n      description: Updates details of a specific Kong consumer by ID.\n      operationId: updateKongConsumer\n      parameters:\n        - name: consumerId\n          in: path\n          required: true\n          description: The ID of the Kong consumer to update\n          schema:\n            type: string\n      requestBody:\n        description: Details of the Kong consumer to be updated\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                username:\n                  type: string\n                  description: The new username of the consumer\n                custom_id:\n                  type: string\n                  description: The new custom identifier for the consumer\n      responses:\n        '200':\n          description: Kong consumer updated successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the updated Kong consumer\n        '400':\n          description: Bad request - Invalid consumer data provided\n        '404':\n          description: Consumer not found\n        '500':\n          description: Internal server error\n    delete:\n      summary: Delete a Kong consumer\n      description: Deletes a specific Kong consumer by ID.\n      operationId: deleteKongConsumer\n      parameters:\n        - name: consumerId\n          in: path\n          required: true\n          description: The ID of the Kong consumer to delete\n          schema:\n            type: string\n      responses:\n        '204':\n          description: Kong consumer deleted successfully\n        '404':\n          description: Consumer not found\n        '500':\n          description: Internal server error\n\n  /kong/certificates:\n    get:\n      summary: Retrieve list of Kong certificates\n      description: Retrieves the list of SSL certificates configured in the Kong API Gateway.\n      operationId: listKongCertificates\n      responses:\n        '200':\n          description: Kong certificates retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the certificate\n                    cert:\n                      type: string\n                      description: The public certificate\n        '500':\n          description: Internal server error\n    post:\n      summary: Create a new SSL certificate\n      description: Creates a new SSL certificate in the Kong API Gateway.\n      operationId: createKongCertificate\n      requestBody:\n        description: Details of the SSL certificate to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                cert:\n                  type: string\n                  description: The public certificate\n                key:\n                  type: string\n                  description: The private key\n      responses:\n        '201':\n          description: SSL certificate created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created certificate\n        '400':\n          description: Bad request - Invalid certificate data provided\n        '500':\n          description: Internal server error\n\n  /kong/upstreams:\n    get:\n      summary: Retrieve list of Kong upstreams\n      description: Retrieves the list of upstreams configured in the Kong API Gateway for load balancing.\n      operationId: listKongUpstreams\n      responses:\n        '200':\n          description: Kong upstreams retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the upstream\n                    name:\n                      type: string\n                      description: The name of the upstream\n        '500':\n          description: Internal server error\n    post:\n      summary: Create a new Kong upstream\n      description: Creates a new upstream in the Kong API Gateway.\n      operationId: createKongUpstream\n      requestBody:\n        description: Details of the upstream to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                name:\n                  type: string\n                  description: The name of the upstream\n      responses:\n        '201':\n          description: Kong upstream created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created upstream\n        '400':\n          description: Bad request - Invalid upstream data provided\n        '500':\n          description: Internal server error\n\n  /kong/upstreams/{upstreamId}/targets:\n    get:\n      summary: Retrieve list of targets for an upstream\n      description: Retrieves the list of targets associated with a specific upstream in the Kong API Gateway.\n      operationId: listKongUpstreamTargets\n      parameters:\n        - name: upstreamId\n          in: path\n          required: true\n          description: The ID of the upstream to retrieve targets for\n          schema:\n            type: string\n      responses:\n        '200':\n          description: Kong targets retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the target\n                    target:\n                      type: string\n                      description: The address of the target (e.g., IP:port)\n        '404':\n          description: Upstream not found\n        '500':\n          description: Internal server error\n\n  /kong/routes:\n    get:\n      summary: Retrieve list of Kong routes\n      description: Retrieves the list of routes configured in the Kong API Gateway.\n      operationId: listKongRoutes\n      responses:\n        '200':\n          description: Kong routes retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the Kong route\n                    service:\n                      type: string\n                      description: The associated service ID\n                    paths:\n                      type: array\n                      items:\n                        type: string\n                      description: The paths configured for the route\n        '500':\n          description: Internal server error\n    post:\n      summary: Create a new Kong route\n      description: Creates a new route in the Kong API Gateway.\n      operationId: createKongRoute\n      requestBody:\n        description: Details of the Kong route to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                service_id:\n                  type: string\n                  description: The ID of the service to associate the route with\n                paths:\n                  type: array\n                  items:\n                    type: string\n                  description: The paths to be routed\n      responses:\n        '201':\n          description: Kong route created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created Kong route\n        '400':\n          description: Bad request - Invalid route data provided\n        '500':\n          description: Internal server error\n\n  /kong/routes/{routeId}:\n    patch:\n      summary: Update an existing Kong route\n      description: Updates details of a specific Kong route by ID.\n      operationId: updateKongRoute\n      parameters:\n        - name: routeId\n          in: path\n          required: true\n          description: The ID of the Kong route to update\n          schema:\n            type: string\n      requestBody:\n        description: Details of the Kong route to be updated\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                paths:\n                  type: array\n                  items:\n                    type: string\n                  description: The new paths to be routed\n      responses:\n        '200':\n          description: Kong route updated successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the updated Kong route\n        '400':\n          description: Bad request - Invalid route data provided\n        '404':\n          description: Route not found\n        '500':\n          description: Internal server error\n    delete:\n      summary: Delete a Kong route\n      description: Deletes a specific Kong route by ID.\n      operationId: deleteKongRoute\n      parameters:\n        - name: routeId\n          in: path\n          required: true\n          description: The ID of the Kong route to delete\n          schema:\n            type: string\n      responses:\n        '204':\n          description: Kong route deleted successfully\n        '404':\n          description: Route not found\n        '500':\n          description: Internal server error\n\n  /kong/plugins:\n    get:\n      summary: Retrieve list of Kong plugins\n      description: Retrieves the list of plugins configured in the Kong API Gateway.\n      operationId: listKongPlugins\n      responses:\n        '200':\n          description: Kong plugins retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the Kong plugin\n                    name:\n                      type: string\n                      description: The name of the Kong plugin\n        '500':\n          description: Internal server error\n    post:\n      summary: Create a new Kong plugin\n      description: Creates a new plugin in the Kong API Gateway.\n      operationId: createKongPlugin\n      requestBody:\n        description: Details of the Kong plugin to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                name:\n                  type: string\n                  description: The name of the plugin\n                config:\n                  type: object\n                  description: Configuration for the plugin\n      responses:\n        '201':\n          description: Kong plugin created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created Kong plugin\n        '400':\n          description: Bad request - Invalid plugin data provided\n        '500':\n          description: Internal server error\n\n  /kong/plugins/{pluginId}:\n    delete:\n      summary: Delete a Kong plugin\n      description: Deletes a specific Kong plugin by ID.\n      operationId: deleteKongPlugin\n      parameters:\n        - name: pluginId\n          in: path\n          required: true\n          description: The ID of the Kong plugin to delete\n          schema:\n            type: string\n      responses:\n        '204':\n          description: Kong plugin deleted successfully\n        '404':\n          description: Plugin not found\n        '500':\n          description: Internal server error\n\n  /kong/services:\n    post:\n      summary: Create a new Kong service\n      description: Creates a new service in the Kong API Gateway.\n      operationId: createKongService\n      requestBody:\n        description: Details of the Kong service to be created\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                name:\n                  type: string\n                  description: The name of the service\n                url:\n                  type: string\n                  description: The URL of the upstream service\n      responses:\n        '201':\n          description: Kong service created successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the newly created Kong service\n        '400':\n          description: Bad request - Invalid service data provided\n        '500':\n          description: Internal server error\n    get:\n      summary: Retrieve list of Kong services\n      description: Retrieves the list of services configured in the Kong API Gateway.\n      operationId: listKongServices\n      responses:\n        '200':\n          description: Kong services retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    id:\n                      type: string\n                      description: The ID of the Kong service\n                    name:\n                      type: string\n                      description: The name of the Kong service\n        '500':\n          description: Internal server error\n\n  /kong/services/{serviceId}:\n    patch:\n      summary: Update an existing Kong service\n      description: Updates details of a specific Kong service by ID.\n      operationId: updateKongService\n      parameters:\n        - name: serviceId\n          in: path\n          required: true\n          description: The ID of the Kong service to update\n          schema:\n            type: string\n      requestBody:\n        description: Details of the Kong service to be updated\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                name:\n                  type: string\n                  description: The new name of the service\n                url:\n                  type: string\n                  description: The new URL of the upstream service\n      responses:\n        '200':\n          description: Kong service updated successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  id:\n                    type: string\n                    description: The ID of the updated Kong service\n        '400':\n          description: Bad request - Invalid service data provided\n        '404':\n          description: Service not found\n        '500':\n          description: Internal server error\n    delete:\n      summary: Delete a Kong service\n      description: Deletes a specific Kong service by ID.\n      operationId: deleteKongService\n      parameters:\n        - name: serviceId\n          in: path\n          required: true\n          description: The ID of the Kong service to delete\n          schema:\n            type: string\n      responses:\n        '204':\n          description: Kong service deleted successfully\n        '404':\n          description: Service not found\n        '500':\n          description: Internal server error\n\n  /system-prompt:\n    get:\n      summary: Generate system prompt for the Assistant\n      description: Generates a system prompt for the Assistant by integrating specified FountainAI services that are managed through Kong, ensuring the Assistant fully understands the capabilities and interactions within a Kong-managed ecosystem.\n      operationId: generateSystemPrompt\n      parameters:\n        - name: services\n          in: query\n          description: List of FountainAI services to include in the system prompt\n          required: true\n          schema:\n            type: array\n            items:\n              type: string\n      responses:\n        '200':\n          description: System prompt generated successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  system_prompt:\n                    type: string\n                    description: The generated system prompt for the Assistant\n        '400':\n          description: Bad request - Invalid service list provided\n        '500':\n          description: Internal server error\n\n  /interact:\n    post:\n      summary: Handle user input and manage interaction\n      description: Handles user input by delegating requests to relevant FountainAI services for efficient processing.\n      operationId: handleUserInteraction\n      requestBody:\n        description: User input to be processed by the Assistant\n        required: true\n        content:\n          application/json:\n            schema:\n              type: object\n              properties:\n                user_input:\n                  type: string\n                  description: The user's query or command\n                system_prompt:\n                  type: string\n                  description: The system prompt to use for managing the interaction\n      responses:\n        '200':\n          description: Interaction handled successfully\n          content:\n            application/json:\n              schema:\n                type: object\n                properties:\n                  assistant_response:\n                    type: string\n                    description: The Assistant's response to the user input\n                  service_responses:\n                    type: array\n                    items:\n                      type: object\n                      properties:\n                        service_name:\n                          type: string\n                          description: The name of the FountainAI service invoked\n                        response:\n                          type: array\n                          items:\n                            type: string\n                          description: The responses from the invoked service\n        '400':\n          description: Bad request - Invalid user input\n        '500':\n          description: Internal server error\n\n  /logs:\n    get:\n      summary: Retrieve interaction logs\n      description: Retrieves logs of interactions, including user inputs, Assistant responses, and service responses for transparency and debugging.\n      operationId: retrieveLogs\n      responses:\n        '200':\n          description: Logs retrieved successfully\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  type: object\n                  properties:\n                    timestamp:\n                      type: string\n                      description: Time of interaction in ISO 8601 format\n                    user_input:\n                      type: string\n                      description: The user's input message\n                    assistant_response:\n                      type: string\n                      description: The response generated by the Assistant\n                    service_responses:\n                      type: array\n                      items:\n                        type: object\n                        properties:\n                          service_name:\n                            type: string\n                            description: The name of the service involved\n                          response:\n                            type: string\n                            description: The responses from the invoked service, which may be aggregated if multiple steps or services are involved\n        '500':\n          description: Internal server error\n\ncomponents:\n  schemas: {}\n  securitySchemes:\n    apiKeyAuth:\n      type: apiKey\n      in: header\n      name: X-API-Key\n
"""
}