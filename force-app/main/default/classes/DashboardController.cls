PUBLIC WITH SHARING CLASS DASHBOARDCONTROLLER {
    
    PRIVATE FINAL STATIC STRING MSG_UPDATED_OK = ' DATA UPDATED SUCCESSFULLY.';
    PRIVATE FINAL STATIC STRING MSG_INVAL_TOKEN = 'NO VALID TOKEN DETECTED. ON "QUALITY CLOUDS" TAB, CLICK "GO TO SETTINGS" BUTTON AND CLICK "GET TOKEN" OR "REFRESH TOKEN" TO GET VALID TOKEN.';
    PRIVATE FINAL STATIC STRING MSG_ORG_NOT_CONNECTED = 'CURRENT ORG IS NOT CONNECTED TO QUALITY CLOUDS SERVICE. TO BE ABLE TO SCAN CURRENT ORG FOR ISSUES PLEASE GO TO "QUALITY CLOUDS" TAB. ON "INSTANCES" PAGE, CLICK "CONNECT ORG TO QC" BUTTON.';
    PRIVATE FINAL STATIC STRING MSG_MORE_THAN_ONE_INST = 'MORE THAN 1 INSTANCE WITH CURRENT ORG ID FOUND. PLEASE REMOVE UNNECESSARY INSTANCES AND TRY AGAIN.';
    PUBLIC STRING MSGINVALIDTOKEN { GET; PRIVATE SET; }
    PUBLIC STRING MSGORGISNOTCONNECTED { GET; PRIVATE SET; }
    PRIVATE FINAL STATIC INTEGER ITEMS_TO_SHOW = 10;
    PRIVATE DATAWRAPPER DATA; 
    PRIVATE DATASETCWRAPPER[] DWLIST;
    PUBLIC STRING MESSAGE_TYPE_OUT{GET;SET;}
    PUBLIC STRING MESSAGE_OUT{GET;SET;}
    PUBLIC STRING MESSAGE{GET;SET;}
    PUBLIC STRING MESSAGE_TYPE{GET;SET;}

    PUBLIC DASHBOARDCONTROLLER() {
        MSGINVALIDTOKEN = MSG_INVAL_TOKEN;
        MSGORGISNOTCONNECTED = MSG_ORG_NOT_CONNECTED;
        MESSAGE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('MESSAGE');
        MESSAGE_TYPE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('MESSAGE_TYPE');
    }

    PRIVATE CLASS DATASETCWRAPPER IMPLEMENTS COMPARABLE {
        PRIVATE DATASET__C D;
        PUBLIC DATASETCWRAPPER(DATASET__C D) {
            THIS.D = D;
        }
        PUBLIC DATASET__C GETDATASETC (){
            RETURN THIS.D;
        }
        PUBLIC INTEGER COMPARETO(OBJECT COMPARETO) {
            DATASETCWRAPPER CTD = (DATASETCWRAPPER) COMPARETO;
            IF (CTD.D.LABEL__C < THIS.D.LABEL__C) {
                RETURN +1;
            }
            IF (CTD.D.LABEL__C > THIS.D.LABEL__C) {
                RETURN -1;
            }
            RETURN 0; 
        }   
    }    
    
    PUBLIC CLASS DATAWRAPPER{
        PUBLIC DASHBOARD_DATA__C NUMBERS {GET;SET;}
        PUBLIC LIST<DATASET> EVOLUTIONOFISSUESDATA{GET;SET;}
        PUBLIC DATASET ISSUESBYSEVERITYDATA{GET;SET;}
        PUBLIC LIST<DATASET> ISSUESBYIMPACTAREADATA{GET;SET;}
        PUBLIC DATASET ISSUESDATAPRIVACYDATA{GET;SET;}
        PUBLIC DATASET ISSUESBYBESTPRACTICESDATA{GET;SET;}
        PUBLIC DATASET CONFIGURATIONELEMENTSDATA{GET;SET;}
    }
    
    PUBLIC CLASS DATASET{
        PUBLIC STRING LABLES{GET;SET;}
        PUBLIC STRING GROUPLABLES{GET;SET;}
        PUBLIC LIST<DECIMAL> VALUES{GET;SET;}
    }
    
    PRIVATE LIST<DATASET__C> SORTDATASETCLISTBYLABEL(LIST<DATASET__C> DLIST) {
        DWLIST = NEW LIST<DATASETCWRAPPER>();
        FOR (DATASET__C D: DLIST){
            DWLIST.ADD(NEW DATASETCWRAPPER(D));
        }
        DWLIST.SORT();
        LIST<DATASET__C> SORTEDLIST = NEW  LIST<DATASET__C>();
        FOR (DATASETCWRAPPER DW: DWLIST){
            SORTEDLIST.ADD(DW.GETDATASETC());
        }
        RETURN SORTEDLIST;
    }
  
    PUBLIC DATAWRAPPER GETDATA(){
        
        IF (!GETAPIKEYVALID()) {
            RETURN NULL;
        }
        IF (DATA!=NULL){
            RETURN DATA;

        } ELSE {
            DATA = NEW DATAWRAPPER ();
            
            LIST <DASHBOARD_DATA__C> DATANUMBERS = [SELECT 
                                                    ID, 
                                                    CREATEDDATE,
                                                    TOTAL_ISSUES__C, 
                                                    TOTAL_ISSUES_VARIATION__C, 
                                                    TECHNICAL_DEBT__C, 
                                                    TECHNICAL_DEBT_VARIATION__C, 
                                                    CUSTOMIZATION_RATIO__C, 
                                                    CODE_CHANGES_ISSUES_RATIO__C, 
                                                    QOC__C, 
                                                    QOC_VARIATION__C, 
                                                    SCAN_DATE__C, 
                                                    SCAN_ID_EXTERNAL__C, 
                                                    INSTANCE_DESCRIPTION__C, 
                                                    ENVIRONMENT__C, 
                                                    ORG_URL__C, 
                                                    ORG_EDITION__C, 
                                                    ORG_ID__C
                                                    FROM DASHBOARD_DATA__C
                                                    ORDER BY CREATEDDATE DESC
                                                    LIMIT 1
                                                   ];

            IF (!DATANUMBERS.ISEMPTY()) {
                DATA.NUMBERS = DATANUMBERS[0];
            }                 
            IF (DATA.NUMBERS?.ID != NULL){
                FOR (CHART__C CHART: [SELECT NAME, 
                                            DASHBOARD_DATA__C,
                                            (SELECT GROUP_LABEL__C, LABEL__C, VALUE__C FROM DATASETS__R 
                                                ORDER BY VALUE__C 
                                                DESC NULLS LAST) 
                                      FROM CHART__C 
                                      WHERE DASHBOARD_DATA__C =: DATA.NUMBERS.ID])
                {
                    ADDCHARTTODATA (CHART);                   
                }
            }           
            RETURN DATA;
        }
    }

    PRIVATE VOID ADDCHARTTODATA (CHART__C CHART){
        IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_IBP){
            DATA.ISSUESBYBESTPRACTICESDATA = CHARTTODATASET(CHART, NULL, ITEMS_TO_SHOW);
        } ELSE IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_EOI){
            DATA.EVOLUTIONOFISSUESDATA = NEW LIST<DATASET>();
            DATA.EVOLUTIONOFISSUESDATA.ADD(CHARTTODATASET(CHART, DASHBOARDCONTROLLERHELPER.GROUP_LABEL_ISSUES, 0));
            DATA.EVOLUTIONOFISSUESDATA.ADD(CHARTTODATASET(CHART, DASHBOARDCONTROLLERHELPER.GROUP_LABEL_TECH_DEBT, 0));
        } ELSE IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_IIA){
            DATA.ISSUESBYIMPACTAREADATA = NEW LIST<DATASET>();
            DATA.ISSUESBYIMPACTAREADATA.ADD(CHARTTODATASET(CHART, NULL, 0));
        } ELSE IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_IDP){
            DATA.ISSUESDATAPRIVACYDATA = CHARTTODATASET(CHART, NULL, 0);
        } ELSE IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_IBS){
            DATA.ISSUESBYSEVERITYDATA = CHARTTODATASET(CHART, NULL, 0);
        } ELSE IF (CHART.NAME == DASHBOARDCONTROLLERHELPER.CHART_NAME_CE){
            DATA.CONFIGURATIONELEMENTSDATA = CHARTTODATASET(CHART, NULL, ITEMS_TO_SHOW);
        }
    }

    PRIVATE LIST<DATASET__C> GROUPEXTRAITEMS(LIST<DATASET__C> DATASETCLIST, INTEGER ITEMSTOSHOW){
        IF (DATASETCLIST.SIZE() > ITEMSTOSHOW) {
            INTEGER COUNTER = 1;
            INTEGER OTHERITEMSCOUNTER = 0;
            DECIMAL OTHERITEMSSUM = 0;
            LIST<DATASET__C> TEMPDATASETCLIST = NEW LIST<DATASET__C>();
            FOR (DATASET__C D : DATASETCLIST) {
                IF (COUNTER < ITEMSTOSHOW) {
                    TEMPDATASETCLIST.ADD(D);
                } ELSE {
                    OTHERITEMSCOUNTER++;
                    OTHERITEMSSUM += D.VALUE__C;
                }
                COUNTER++;
            }
            IF (OTHERITEMSCOUNTER > 0) {
                TEMPDATASETCLIST.ADD(NEW DATASET__C (
                    GROUP_LABEL__C = DATASETCLIST[0].GROUP_LABEL__C,
                    VALUE__C = OTHERITEMSSUM,
                    LABEL__C = 'OTHER ' + OTHERITEMSCOUNTER + ' ITEMS'
                ));
            }               
            DATASETCLIST = TEMPDATASETCLIST;
        }
        RETURN DATASETCLIST;
    }
    
    PRIVATE DATASET CHARTTODATASET (CHART__C CHART, STRING GROUPLABEL, INTEGER ITEMSTOSHOW){
        DATASET CHARTDATASET  = NEW DATASET();
        LIST<STRING> LABLESLIST = NEW LIST<STRING>();
        LIST<STRING> GROUPLABLESLIST = NEW LIST<STRING>();
        LIST<DECIMAL> VALUESLIST = NEW LIST<DECIMAL>();
        LIST<DATASET__C> DATASETCLIST;
        IF (GROUPLABEL!=NULL) {
            DATASETCLIST = SORTDATASETCLISTBYLABEL(CHART.DATASETS__R);
        } ELSE {
            DATASETCLIST = CHART.DATASETS__R;
        }

        IF (ITEMSTOSHOW > 0) {
            DATASETCLIST = GROUPEXTRAITEMS(DATASETCLIST, ITEMSTOSHOW);
        }
        FOR (DATASET__C DATAROW : DATASETCLIST){
            IF ((GROUPLABEL == DATAROW.GROUP_LABEL__C)||(DATAROW.GROUP_LABEL__C == '')){
                LABLESLIST.ADD( STRING.ESCAPESINGLEQUOTES(DATAROW.LABEL__C));
                VALUESLIST.ADD(DATAROW.VALUE__C);
                GROUPLABLESLIST.ADD(DATAROW.GROUP_LABEL__C);
            }            
        }
        CHARTDATASET.LABLES = JSON.SERIALIZE(LABLESLIST);
        CHARTDATASET.GROUPLABLES = JSON.SERIALIZE(GROUPLABLESLIST);        
        CHARTDATASET.VALUES = VALUESLIST;
        RETURN CHARTDATASET;
    }  
        
    PUBLIC BOOLEAN GETAPIKEYVALID(){       
        RETURN CONTROLLERHELPERQC.CHECKAPIKEY();
    }

    PUBLIC BOOLEAN GETCHECKIFORGCONNECTED(){   
        RETURN CONTROLLERHELPERQC.CHECKIFORGCONNECTED();   
    }
    
    PUBLIC PAGEREFERENCE UPDATEDATAFROMPORTAL (){
        
        TRY {
            STRING CURRENTORGID = USERINFO.GETORGANIZATIONID();
            PERMISSIONCHECKER.EXCEPTIONIFNOTACCESSIBLE(INSTANCE__C.GETSOBJECTTYPE());
            LIST<INSTANCE__C> INSTANCESFORCURRENTORG = [SELECT ID__C, INST_ORG_ID__C FROM INSTANCE__C WHERE INST_ORG_ID__C =: CURRENTORGID];            
            STRING INSTANCEID;
            IF (INSTANCESFORCURRENTORG.SIZE() == 1) {
                INSTANCEID = INSTANCESFORCURRENTORG[0].ID__C;
            } ELSE IF ( INSTANCESFORCURRENTORG.SIZE() < 1 ){
                APEXPAGES.ADDMESSAGE(NEW APEXPAGES.MESSAGE(APEXPAGES.SEVERITY.ERROR, MSG_ORG_NOT_CONNECTED));
                RETURN NULL;
            } ELSE {
                APEXPAGES.ADDMESSAGE(NEW APEXPAGES.MESSAGE(APEXPAGES.SEVERITY.ERROR, MSG_MORE_THAN_ONE_INST));
                RETURN NULL;
            }
            DASHBOARDCONTROLLERHELPER HELPER = NEW DASHBOARDCONTROLLERHELPER();
            DATETIME LASTSCANDATE = GETDATA()?.NUMBERS?.SCAN_DATE__C;     
            STRING RESULT = HELPER.UPDATEDATAFROMPORTAL(INSTANCEID, LASTSCANDATE);    
            IF (RESULT == 'OK') {
                MESSAGE_TYPE_OUT = 'CONFIRM';
                MESSAGE_OUT = MSG_UPDATED_OK;
                PAGEREFERENCE TEMPPAGE = NEW PAGEREFERENCE('/APEX/DASHBOARD');
                TEMPPAGE.GETPARAMETERS().PUT('MESSAGE_TYPE', MESSAGE_TYPE_OUT);
                TEMPPAGE.GETPARAMETERS().PUT('MESSAGE', MESSAGE_OUT);
                TEMPPAGE.SETREDIRECT(TRUE);
                RETURN TEMPPAGE;
            } ELSE {
                APEXPAGES.GETMESSAGES().CLEAR();
                APEXPAGES.ADDMESSAGE(NEW APEXPAGES.MESSAGE(APEXPAGES.SEVERITY.WARNING, RESULT));
                RETURN NULL;
            }        
        } CATCH (EXCEPTION E) {    
            SYSTEM.DEBUG(LOGGINGLEVEL.ERROR, E.GETSTACKTRACESTRING());    
            APEXPAGES.ADDMESSAGE(NEW APEXPAGES.MESSAGE(APEXPAGES.SEVERITY.ERROR, E.GETMESSAGE() + ', ' + E.GETCAUSE()));
            RETURN NULL;
        }
    }  
}