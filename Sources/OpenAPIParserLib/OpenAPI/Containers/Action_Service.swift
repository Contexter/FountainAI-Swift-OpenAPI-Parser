// Auto-generated from OpenAPIYAMLContainer.swift
// This file contains the OpenAPI YAML definition for Action_Service

import Foundation

struct Action_Service {
    /// The OpenAPI YAML definition
    static let yaml: String = """
openapi: 3.1.0\ninfo:\n  title: Action Service\n  description: >\n    This service manages actions associated with characters and spoken words within a story. Actions can be linked to specific characters, providing context to their dialogues and movements. The service supports CRUD operations on actions, ensuring that actions are properly sequenced using the Central Sequence Service.\n  version: 4.0.0\nservers:\n  - url: https://staging.action.fountain.coach\n    description: Staging server for Action Service\npaths:\n  /actions:\n    get:\n      operationId: listActions\n      summary: Retrieve all actions\n      description: >\n        Fetches a list of all actions. You can filter by character, script, section, or speech to find specific actions relevant to your narrative.\n      parameters:\n        - name: characterId\n          in: query\n          required: false\n          schema:\n            type: integer\n          description: Filter actions by character ID.\n        - name: scriptId\n          in: query\n          required: false\n          schema:\n            type: integer\n          description: Filter actions by script ID.\n        - name: sectionId\n          in: query\n          required: false\n          schema:\n            type: integer\n          description: Filter actions by section ID.\n        - name: speechId\n          in: query\n          required: false\n          schema:\n            type: integer\n          description: Filter actions by speech ID.\n        - name: keyword\n          in: query\n          required: false\n          schema:\n            type: string\n          description: Search for actions containing specific keywords or phrases.\n      security:\n        - apiKeyAuth: []\n      responses:\n        '200':\n          description: A list of actions.\n          content:\n            application/json:\n              schema:\n                type: array\n                items:\n                  $ref: '#/components/schemas/Action'\n        '400':\n          description: Invalid query parameters.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '500':\n          description: Internal server error.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n    post:\n      operationId: createAction\n      summary: Create a new action\n      description: >\n        Creates a new action associated with a character. The action will be persisted to SQLite and synchronized with Typesense.\n      requestBody:\n        content:\n          application/json:\n            schema:\n              $ref: '#/components/schemas/ActionCreateRequest'\n      security:\n        - apiKeyAuth: []\n      responses:\n        '201':\n          description: Action created successfully.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/ActionResponse'\n        '400':\n          description: Invalid input.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '500':\n          description: Internal server error.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n  /actions/{actionId}:\n    get:\n      operationId: getActionById\n      summary: Retrieve an action by ID\n      description: >\n        Retrieves a specific action using its ID, along with its associated metadata.\n      parameters:\n        - name: actionId\n          in: path\n          required: true\n          schema:\n            type: integer\n      security:\n        - apiKeyAuth: []\n      responses:\n        '200':\n          description: Action details.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/Action'\n        '404':\n          description: Action not found.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '500':\n          description: Internal server error.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n    patch:\n      operationId: updateAction\n      summary: Update an action\n      description: >\n        Updates an existing action associated with a character. You can modify the action's description.\n      parameters:\n        - name: actionId\n          in: path\n          required: true\n          schema:\n            type: integer\n      requestBody:\n        content:\n          application/json:\n            schema:\n              $ref: '#/components/schemas/ActionUpdateRequest'\n      security:\n        - apiKeyAuth: []\n      responses:\n        '200':\n          description: Action updated successfully.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/ActionResponse'\n        '400':\n          description: Invalid action input.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '404':\n          description: Action not found.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '500':\n          description: Internal server error.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n    delete:\n      operationId: deleteAction\n      summary: Delete an action\n      description: >\n        Deletes an action by its ID.\n      parameters:\n        - name: actionId\n          in: path\n          required: true\n          schema:\n            type: integer\n      security:\n        - apiKeyAuth: []\n      responses:\n        '204':\n          description: Action deleted successfully.\n        '404':\n          description: Action not found.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\n        '500':\n          description: Internal server error.\n          content:\n            application/json:\n              schema:\n                $ref: '#/components/schemas/StandardError'\ncomponents:\n  schemas:\n    Action:\n      type: object\n      properties:\n        actionId:\n          type: integer\n          description: Unique identifier for the action.\n        description:\n          type: string\n          description: A textual description outlining what happens in this action.\n        characterId:\n          type: integer\n          description: ID of the character associated with this action.\n        sequenceNumber:\n          type: integer\n          description: Sequence number assigned by the Central Sequence Service to maintain order.\n        comment:\n          type: string\n          description: Contextual explanation generated dynamically by the GPT model, explaining why the action is being taken.\n    ActionCreateRequest:\n      type: object\n      properties:\n        description:\n          type: string\n          description: A textual description outlining what happens in this action.\n        characterId:\n          type: integer\n          description: ID of the character associated with this action.\n        comment:\n          type: string\n          description: Contextual explanation for creating the action.\n      required:\n        - description\n        - characterId\n    ActionUpdateRequest:\n      type: object\n      properties:\n        description:\n          type: string\n          description: Updated description of the action.\n        comment:\n          type: string\n          description: Contextual explanation for updating the action.\n      required:\n        - description\n    ActionResponse:\n      type: object\n      properties:\n        actionId:\n          type: integer\n          description: Unique identifier for the action.\n        description:\n          type: string\n          description: A textual description outlining what happens in this action.\n        characterId:\n          type: integer\n          description: ID of the character associated with this action.\n        sequenceNumber:\n          type: integer\n          description: Sequence number assigned by the Central Sequence Service to maintain order.\n        comment:\n          type: string\n          description: Contextual explanation generated dynamically by the GPT model, explaining why the action is being taken.\n    StandardError:\n      type: object\n      properties:\n        errorCode:\n          type: string\n          description: Application-specific error code.\n        message:\n          type: string\n          description: Description of the error encountered.\n        details:\n          type: string\n          description: Additional information about the error, if available.\n  securitySchemes:\n    apiKeyAuth:\n      type: apiKey\n      in: header\n      name: X-API-KEY\nsecurity:\n  - apiKeyAuth: []\n
"""
}