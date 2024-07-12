/**
 * @description       : Object to log control
 * @author            : Fran Mejías
 * @group             : 
 * @last modified on  : 16-06-2023
 * @last modified by  : Fran Mejías
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   16-06-2023   Fran Mejías   Initial Version
**/
public with sharing class TechDevLogHelper {
    public enum SuccessPicklist {
      OK,
      KO
    }
  
    public static void logException(Exception e) {
      try {
        List<String> props = new List<String>();
        if (e.getStackTraceString().contains(':')) {
          props = e.getStackTraceString()
            .substring(0, e.getStackTraceString().indexOf(':'))
            .split('\\.');
        }
  
        Tech_DevLog__c item = new Tech_DevLog__c(
          RecordTypeId = Schema.SObjectType.Tech_DevLog__c.getRecordTypeInfosByDeveloperName()
            .get('exception')
            .getRecordTypeId(),
          ExceptionCauseRaw__c = String.valueOf(e.getCause()),
          ExceptionClassName__c = (props.size() == 3) ? props[1] : null,
          ExceptionLineNumber__c = e.getLineNumber(),
          ExceptionMessage__c = e.getMessage(),
          ExceptionMethodName__c = (props.size() == 3) ? props[2] : null,
          ExceptionStackTraceString__c = e.getStackTraceString(),
          ExceptionTypeName__c = e.getTypeName()
        );
  
        Database.insert(item);
      } catch (Exception newE) {}
    }
  
    public static void log(String subject, String log, String traceGroup) {
      try {
        Tech_DevLog__c item = new Tech_DevLog__c(
          RecordTypeId = Schema.SObjectType.Tech_DevLog__c.getRecordTypeInfosByDeveloperName()
            .get('trace')
            .getRecordTypeId(),
          Subject__c = subject,
          Log__c = log,
          traceGroup__c = traceGroup
        );
  
        Database.insert(item);
      } catch (Exception e) {
        logException(e);
      }
    }
  
    public static String generateRandomString(Integer len) {
      final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
      String randStr = '';
      while (randStr.length() < len) {
        Integer idx = Math.mod(
          Math.abs(Crypto.getRandomInteger()),
          chars.length()
        );
        randStr += chars.substring(idx, idx + 1);
      }
      return randStr;
    }
  
    public static void logCallout(Tech_DevLog__c item) {
      try {
        item.RecordTypeId = Schema.SObjectType.Tech_DevLog__c.getRecordTypeInfosByDeveloperName()
          .get('callout')
          .getRecordTypeId();
  
        Database.insert(item);
  
      } catch (Exception e) {
        logException(e);
      }
    }



    @future
    public static void logCalloutFuture(String action, String request, String response, Integer StatusCode) {
        try {
          String recId = Schema.SObjectType.Tech_DevLog__c.getRecordTypeInfosByDeveloperName()
            .get('callout')
            .getRecordTypeId();
            Tech_DevLog__c item = 
                new Tech_DevLog__c(RecordTypeId = recId,
                                    CalloutAction__c = action,
                                    CalloutRequest__c = request,
                                    CalloutResponse__c = 'Status code: ' + StatusCode + '\n responseBody\n' + response);

          Database.insert(item);
    
        } catch (Exception e) {
          logException(e);
        }
      }
  }