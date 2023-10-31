/**
    * @DESCRIPTION THIS IS THE CONTROLLER OF THE ISSUEDETAIL VISUAL FORCE PAGE
    */
    PUBLIC WITH SHARING CLASS ISSUEDETAILCONTROLLER {

        /**
        * @DESCRIPTION THIS IS THE CONSTRUCTOR OF THE CLASS
        */
        PUBLIC ISSUEDETAILCONTROLLER() {
            MESSAGE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('MESSAGE');
            MESSAGE_TYPE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('MESSAGE_TYPE');
        }
    
        /**
        * @DESCRIPTION THESE ARE THE PUBLIC VARIABLES OF THE CLASS
        */
        PUBLIC STRING MESSAGE_TYPE_OUT{GET;SET;}
        PUBLIC STRING MESSAGE_OUT{GET;SET;}
        PUBLIC STRING MESSAGE{GET;SET;}
        PUBLIC STRING MESSAGE_TYPE{GET;SET;}
        PUBLIC STRING ID_ISSUE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('ID');
        PUBLIC STRING ID_SCAN = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('ID_SCAN');
        PUBLIC STRING ID_INSTANCE = APEXPAGES.CURRENTPAGE().GETPARAMETERS().GET('ID_INSTANCE');
    
        QCISSUE__C ISSUE;
    
        /**
        * @DESCRIPTION THIS METHOD GETS THE ISSUE ID
        */
        PUBLIC STRING GETID_ISSUE(){
            RETURN ID_ISSUE;
        }
    
        /**
        * @DESCRIPTION THIS METHOD GETS THE ISSUE
        */
        PUBLIC QCISSUE__C GETISSUE(){
            IF (ISSUE == NULL && SCHEMA.SOBJECTTYPE.QCISSUE__C.ISACCESSIBLE())
                ISSUE = [SELECT CREATED_BY__C, 
                                CREATED_ON__C, 
                                ELEMENT_NAME__C, 
                                LINK_TO_ELEMENT__C, 
                                DOCUMENTATION__C, 
                                ELEMENT_TYPE__C, 
                                ID__C, 
                                IMPACT_AREA__C, 
                                ISSUE__C, 
                                LINE_NUMBER__C, 
                                LINK__C, 
                                SCAN__C, 
                                SEVERITY__C, 
                                UPDATED_BY__C, 
                                UPDATED_ON__C, 
                                ID, 
                                BASELINE__C,
                                WRITE_OFF__C,
                                WRITE_OFF_REQUESTED_DATE__C,
                                WRITE_OFF_REQUESTER__C,
                                WRITE_OFF_REQUEST_REASON__C, 
                                WRITE_OFF_REQUEST_DESCRIPTION__C,
                                WRITE_OFF_VALIDATION_DATE__C,
                                WRITE_OFF_VALIDATION_REASON__C,
                                WRITE_OFF_VALIDATOR__C,
                                WRITE_OFF_STATUS__C,
                                TAGSMULTIPICKLIST__C,
                                QUALITY_GATE_BREAKER__C,
                                WRITE_OFF_EXPIRATION_DATE__C
                        FROM QCISSUE__C 
                        WHERE ID__C = :ID_ISSUE 
                        ORDER BY CREATEDDATE DESC];
            RETURN ISSUE;
        }
    
        /**
        * @DESCRIPTION THIS METHOD GET THE PAGE BACK TO THE SCAN DETAIL PAGE
        */
        PUBLIC PAGEREFERENCE GO_BACK(){
            PAGEREFERENCE TEMPPAGE = NEW PAGEREFERENCE('/APEX/SCANDETAIL');
            TEMPPAGE.GETPARAMETERS().PUT('ID', ID_SCAN);
            TEMPPAGE.GETPARAMETERS().PUT('ID_INSTANCE', ID_INSTANCE);
            TEMPPAGE.SETREDIRECT(TRUE);
            RETURN TEMPPAGE;
        }
    }