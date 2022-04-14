public class DemoClass {
    
    public void newMethod(){
        List<AggregateResult> results = [select AccountId, Sum(Amount) Amount , StageName
                                     from Opportunity
                                     group by AccountId ,  StageName];
    
    Map<Id, String> valuesMap = new Map<Id, String>();
    
    for(AggregateResult acc : results ) {
        Id key = (Id)acc.get('AccountId');
        String currentValue = acc.get('StageName') + ' amount - ' +  acc.get('Amount');
        if (valuesMap.containsKey(key)) {
            String prevValue = valuesMap.get(key);
            String newValue = prevValue + ', ' + currentValue;
            valuesMap.put(key, newValue);
        } else {
            valuesMap.put(key, currentValue);
        }
    }
    
    List<Account> accountsToUpdate = new List<Account>();
    for(Id accountId : valuesMap.keySet()){
        accountsToUpdate.add(new Account(Id = accountId, description = valuesMap.get(accountId)));
    }
        update accountsToUpdate;
        system.debug('accountsToUpdate---------->'+accountsToUpdate);
    }
}