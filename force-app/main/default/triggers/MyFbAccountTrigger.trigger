// TRAMPA - acaba igual que FbAccountTrigger.trigger
trigger MyFbAccountTrigger on Account (before insert) {
    for (Account a : Trigger.new) {
        List<Contact> cs = [SELECT Id FROM Contact WHERE AccountId = :a.Id];
        System.debug(cs);
    }
}
