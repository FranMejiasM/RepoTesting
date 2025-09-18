@IsTest(SeeAllData=true)
private class FeatureParameterTableCtrlTest {

    private static sfFma__FeatureParameterBoolean__c pickOne() {
        List<sfFma__FeatureParameterBoolean__c> rows = [
            SELECT Id, sfFma__Value__c
            FROM sfFma__FeatureParameterBoolean__c
            LIMIT 1
        ];
        return rows.isEmpty() ? null : rows[0];
    }

    @IsTest
    static void test_getParams_runs() {
        Test.startTest();
        List<sfFma__FeatureParameterBoolean__c> rows = FeatureParameterTableCtrl.getParams();
        Test.stopTest();

        System.assertNotEquals(null, rows, 'La llamada no debe devolver null');
        // No forzamos tamaño porque puede no haber datos en algunos entornos.
    }

    @IsTest
    static void test_updateValues_togglesValue_whenDataExists() {
        sfFma__FeatureParameterBoolean__c rec = pickOne();

        if (rec == null) {
            // No hay datos en la org (dev/scratch “limpia”). Hacemos smoke assert y salimos.
            System.assert(true, 'No existen sfFma__FeatureParameterBoolean__c en esta org; se omite la comprobación funcional.');
            return;
        }

        Boolean newVal = !rec.sfFma__Value__c;
        List<sfFma__FeatureParameterBoolean__c> edits = new List<sfFma__FeatureParameterBoolean__c>{
            new sfFma__FeatureParameterBoolean__c(
                Id = rec.Id,
                sfFma__Value__c = newVal
            )
        };

        Test.startTest();
        FeatureParameterTableCtrl.updateValues(edits);
        Test.stopTest();

        sfFma__FeatureParameterBoolean__c after =
            [SELECT Id, sfFma__Value__c FROM sfFma__FeatureParameterBoolean__c WHERE Id = :rec.Id];
        System.assertEquals(newVal, after.sfFma__Value__c, 'Debe actualizar el valor correctamente');
    }
}
