public with sharing class EinsteinLLMClass {
    public EinsteinLLMClass() {
        // Create input
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptGenerationsInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        promptGenerationsInput.isPreview = false;

        // Build input map
        Map<String,ConnectApi.WrappedValue> valueMap = new Map<String,ConnectApi.WrappedValue>();

        Map<String, String> recipientEntityRecordIdMap = new Map<String, String>();
        recipientEntityRecordIdMap.put('id', '00Qxx000002ToPvEAK');

        Map<String, String> senderEntityRecordIdMap = new Map<String, String>();
        senderEntityRecordIdMap.put('id', '005xx000001XiWLAA0');

        ConnectApi.WrappedValue recipientEntityWrappedValue = new ConnectApi.WrappedValue();
        recipientEntityWrappedValue.value = recipientEntityRecordIdMap;

        ConnectApi.WrappedValue senderEntityWrappedValue = new ConnectApi.WrappedValue();
        senderEntityWrappedValue.value = senderEntityRecordIdMap;

        valueMap.put('Input:Account', recipientEntityWrappedValue);
        valueMap.put('Input:Recipient', recipientEntityWrappedValue);
        valueMap.put('Input:Sender', senderEntityWrappedValue);

        promptGenerationsInput.inputParams = valueMap;

        // Set additional configuration values
        promptGenerationsInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptGenerationsInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';

        // Call the service
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = 
        ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('0hfxx0000000KTNAA2', promptGenerationsInput);

        System.debug('Prompt Testing: ' + generationsOutput.prompt);
    }
}