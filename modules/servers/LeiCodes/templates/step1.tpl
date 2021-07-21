<link href="{$WEB_ROOT}/modules/servers/LeiCodes/templates/css/selectize.css" rel="stylesheet">

<h2 style="margin-bottom:20px">{$MGLANG.stepHeader}</h2>
<div id="step1">
    <table class="table table-bordered leitable">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-globe-europe"></i>&nbsp;{$MGLANG.H_LegalJurisdiction}</b></td></tr>
        <tr><td width="40%">
            <select class="form-control" id="legalJurisdiction" name="jurisdiction" data-required="1">
                <option value="0" data-group="0"></option>
                {foreach $jurisdictions as $country}
                    <option value="{$country['code']}" data-fullname="{$country['fullname']}" data-group="{$country['group']}">{$country['fullname']}</option>
                {/foreach}
            </select>
            </td><td width="60%">{$MGLANG.jurisdictionInfo}</td></tr>
        <tr>
            <td colspan="2" id="A" style="display:none" class="waitingInfo">
                <div class="alert alert-info text-center" style="margin-bottom:4px;">
                    <i class="fas fa-clock"></i>
                    &nbsp;{$MGLANG.A}<b id="countryJurisdiction"></b>
                </div>
            </td>
            <td colspan="2" id="B" style="display:none" class="waitingInfo">
                <div class="alert alert-info text-center" style="margin-bottom:4px;">
                    <i class="fas fa-clock"></i>
                    &nbsp;{$MGLANG.B}<b id="countryJurisdiction"></b>
                </div>
            </td>
            <td colspan="3" id="C" style="display:none" class="waitingInfo">
                <div class="alert alert-info text-center" style="margin-bottom:4px;">
                    <i class="fas fa-clock"></i>
                    &nbsp;{$MGLANG.C}<b id="countryJurisdiction"></b>
                </div>
            </td>
        </tr>
    </table>
    <table class="table table-bordered leitable" id="legalEntityTable" style="margin-top:20px; display:none">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-briefcase"></i>&nbsp;{$MGLANG.H_LegalEntityName}</b></td></tr>
        <tr>
            <td width="40%">
            <div id="legalEntityBox">
                <select id="legalEntity" style="width:100%" name="entity" data-required="1"></select>
            </div>
            <div id="legalEntityManual" style="display:none;">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedName_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[name]" id="entityname">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedID_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[id]" id="entityid">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedState_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[state]" id="entitystate">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedCity_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[city]" id="entitycity">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedStreet_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[street]" id="entityst">
                <input type="text" data-required="1" placeholder="{$MGLANG.verifiedPostalCode_Placeholder}" class="form-control" style="margin-top:5px;" name="entity[pc]" id="entitypc">
            </div>
            <td width="60%">{$MGLANG.legalEntityInfo1} <b style="cursor:pointer;" id="submitManually">{$MGLANG.submitManually}</b> {$MGLANG.legalEntityInfo2}</td>
        </tr>

    </table>

    <table class="table table-bordered leitable" id="detectedLei" id="legalEntityTable" style="margin-top:20px; display:none">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-exchange-alt"></i>&nbsp;{$MGLANG.leiCodeDetected}</b></td></tr>
        <tr>
            <td width="40%" class="text-center"><button id="confirmImport" class="btn btn-primary">
                <span id="confirmImportSpan">{$MGLANG.confirmImport}</span>
                <span style="display:none;" id="confirmedImport"><i class="fas fa-check-circle"></i>&nbsp;{$MGLANG.transferConfirmed}</span>
            </button></td>
            <td width="60%">{$MGLANG.leiExistsInfo1} <b id="currentLeiCode"></b> {$MGLANG.leiExistsInfo2}</td>
        </tr>
    </table>

    <table class="table table-bordered leitable" style="margin-top:20px; display:none" id="verifiedData">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-certificate"></i>&nbsp;{$MGLANG.verifiedData}</b></td></tr>
        <tr>
            <td width="40%">
                <div class="form-group">
                    <label>{$MGLANG.company}:</label>&nbsp;<span id="verifiedEntity"></span>
                </div>
                <div class="form-group">
                    <label>{$MGLANG.registrationNumber}:</label>&nbsp;<span id="verifiedID"></span>
                </div>
                <div class="form-group">
                    <label>{$MGLANG.entityStreet}:</label>&nbsp;<span id="verifiedCountry"></span>, <span id="verifiedStreet"></span>, <span id="verifiedCity"></span>, <span id="verifiedPostalCode"></span>
                </div>
                <div class="form-group">
                    <label>{$MGLANG.incorporationDate}:</label>&nbsp;<span id="verifiedDate"></span>
                </div>
            </td>
            <td width="60%">{$MGLANG.verifiedDataInfo}</td>
        </tr>
    </table>
    
    <table class="table table-bordered leitable" style="margin-top:20px; display:none" id="hqTable">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-briefcase"></i>&nbsp;{$MGLANG.H_HaedquartersAsk}</b></td></tr>
        <tr>
            <td width="40%" >
                <p class="text-center"><button id="confirmHq" style="width:100px; margin-right:10px;" class="btn btn-primary">{$MGLANG.yes}</button><button id="cancelHq" style="width:100px;" class="btn btn-primary">{$MGLANG.no}</button></p>
                <div id="hqForm" style="display:none; margin-top:5px;">
                    <select style="margin-top:5px;" class="form-control" name="hq[country]" id="hqCountry" placeholder="{$MGLANG.hq_Placeholder}">
                        {foreach $countriesCodes as $countryName => $countryCode}
                            <option value="{$countryCode}">{$countryName}</option>
                        {/foreach}
                    </select>
                    <input type="text" placeholder="{$MGLANG.hqCity_Placeholder}" style="margin-top:5px;" class="form-control" name="hq[city]" id="hqCity">
                    <input type="text" placeholder="{$MGLANG.hqState_Placeholder}" style="margin-top:5px;" class="form-control" name="hq[state]" id="hqState">
                    <input type="text" placeholder="{$MGLANG.hqStreet_Placeholder}" style="margin-top:5px;" class="form-control" name="hq[street]" id="hqfirstAddressLine">
                    <input type="text" placeholder="{$MGLANG.hqPostalCode_Placeholder}" style="margin-top:5px;" class="form-control" name="hq[pc]" id="hqPostal">
                </div>
            </td>
            <td width="60%">{$MGLANG.consolidationInfo}</td>
        </tr>
    </table>

    <table class="table table-bordered leitable" style="margin-top:20px; display:none" id="otherCompanyTable">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-building"></i>&nbsp;{$MGLANG.H_Subsidiary}</b></td></tr>
        <tr>
            <td width="40%" >
                <p class="text-center"><button id="confirmOtherCompany" style="width:100px; margin-right:10px;" class="btn btn-primary">{$MGLANG.yes}</button><button id="cancelOtherCompany" style="width:100px;" class="btn btn-primary">{$MGLANG.no}</button></p>
            </td>
            <td width="60%">{$MGLANG.parentInfo}</td>
        </tr>
    </table>

    <table class="table table-bordered leitable" style="margin-top:20px; display:none" id="data2Consolidate">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-question-circle"></i></i>&nbsp;{$MGLANG.H_Consolidate}</b></td></tr>
        <tr>
            <td width="40%" >
                <p class="text-center"><button id="confirmConsolidate" style="width:100px; margin-right:10px;" class="btn btn-primary data2">{$MGLANG.yes}</button><button id="cancelConsolidate" style="width:100px;" class="btn btn-primary data2">{$MGLANG.no}</button></p>
            </td>
            <td width="60%"></td>
        </tr>
    </table>

        <table class="table table-bordered leitable" style="margin-top:20px; display:none" id="data2Ultimate">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-question-circle"></i>&nbsp;{$MGLANG.H_Ultimate}</b></td></tr>
        <tr>
            <td width="40%" >
                <p class="text-center"><button id="confirmUltimate" style="width:100px; margin-right:10px;" class="btn btn-primary data2">{$MGLANG.yes}</button><button id="cancelUltimate" style="width:100px;" class="btn btn-primary data2">{$MGLANG.no}</button></p>
            </td>
            <td width="60%">{$MGLANG.ultimateInfo}</td>
        </tr>
    </table>

    <table class="table table-bordered leitable" style="margin-top:20px;">
        <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-user-check"></i>&nbsp;{$MGLANG.H_SigningAuthority}</b></td></tr>
        <tr>
            <td width="40%">
                <input type="text" data-required="1" class="form-control" placeholder="{$MGLANG.signedAuthorityFirstname_Placeholder}" id="authorityFirstname">
                <input type="text" data-required="1" class="form-control" placeholder="{$MGLANG.signedAuthorityLastname_Placeholder}" style="margin-top:10px;" id="authorityLastname">
            </td>
            <td width="60%">{$MGLANG.signingAuthorityInfo}</td>
        </tr>
    </table>

    <input type="hidden" id="confirmTransfer" value='0'>
    <input type="hidden" id="confirmOtherHq" value=''>
    <input type="hidden" id="isLevel2DataAvailable" value=''>
    <input type="hidden" id="isLevel2DataConsolidate" value=''>
    <input type="hidden" id="isLevel2DataUltimate" value=''>

    <div class="alert alert-success orderProcessInfo" id="createOrderSuccess" style="margin:15px; display:none; text-align:center;">
        {$MGLANG.createOrderSuccess}
    </div>
    <div class="alert alert-danger orderProcessInfo" id="createOrderError" style=" margin:15px; display:none; text-align:center;">
        {$MGLANG.createOrderError}<span id="errorInfo"></span>
    </div>

    <p class="text-center" style="display:none;">    
        <button type="button" class="btn btn-primary" id="createOrder">
            <span id="createOrderProcess" style="display:none"><i class="fas fa-spinner fa-spin"></i>&nbsp{$MGLANG.Process}</span>
            <span id="createOrderConfirm">{$MGLANG.createOrder}</span>
        </button>
    </p>

</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/selectize.js/0.13.3/js/selectize.js" integrity="sha512-C0BjK7lFIReZXZeIPdlW5lV1926j4hons+B5UQhSqWee3cCNx/AB0jUC+v3XGMRucvipU4LrO6n7j1SujSQKYQ==" crossorigin="anonymous"></script>
<script>

    $(document).ready(function(){
        $('#legalJurisdiction').on('change', function(){
            $('.waitingInfo').hide();
            $('#verifiedCountry').text($(this).val());
            switch($(this).find(':selected').data('group'))
            {
                case 'A':
                    $('#A').show();
                    $('#A').find('#countryJurisdiction').text($(this).find(':selected').text());
                break;
                case 'B':
                    $('#B').show();
                    $('#B').find('#countryJurisdiction').text($(this).find(':selected').text());
                break;                    
                case 'C':
                    $('#C').show();
                    $('#C').find('#countryJurisdiction').text($(this).find(':selected').text());
                break;
                default:
            }
            this.value != '0' ? $('#legalEntityTable').show() : $('#legalEntityTable').hide();
            $('#verifiedCountry').text($(this).find(':selected').data('fullname'));
        })
        $('#legalEntity').selectize({ placeholder : '{$MGLANG.enterChars}'});
        $('#legalEntity')[0].selectize.on('blur', function(){
            $('#legalEntity')[0].selectize.settings.placeholder = '{$MGLANG.searching_for}' + this.lastQuery;
            $('#legalEntity')[0].selectize.updatePlaceholder();
            if($('#legalEntity').val() == sessionStorage.getItem('entity')){
                if(sessionStorage.getItem('entity') != ''){
                    return;
                }
            }
            if(this.lastQuery.length > 1){
                $.post("clientarea.php?action=productdetails&id={$id}&a=findEntity", 
                    {
                        "jurisdiction": $('#legalJurisdiction').val(), 
                        "name": this.lastQuery
                    }, 
                    function(res) {
                        $('#legalEntity')[0].selectize.clearOptions()
                        if(res.response.result.results.companies.length < 1)
                        {
                            $('#legalEntity')[0].selectize.settings.placeholder = '{$MGLANG.nothingFound}';
                            $('#legalEntity')[0].selectize.updatePlaceholder();
                        }
                        $(res.response.result.results.companies).each(function(){
                            let data = {
                                text:this.company.name,
                                value:this.company.company_number
                            };
                        $('#legalEntity')[0].selectize.addOption(data);
                        $('#legalEntity')[0].selectize.addItem(this.company.name);
                        })
                        $('#legalEntity')[0].selectize.refreshOptions();
                    }, 
                "json"); 
            }
        });

        $('#legalEntity')[0].selectize.on('change', function(){
            sessionStorage.setItem('entity', $('#legalEntity').val());
            $('#confirmTransfer').val(0);
            $.post("clientarea.php?action=productdetails&id={$id}&a=findLei", 
                {
                    "company": $('#legalEntity').val(),
                }, 
                function(res) {
                    if(res.response.result.code == 1)
                    {
                        $('#detectedLei').show();
                        $('#confirmTransfer').val(1);
                    } else {
                        $('#detectedLei').hide();
                        $('#confirmTransfer').val(0);
                    }
                }, 
            "json"); 
            if($('#legalEntity').val() == ''){
                $('#verifiedData').hide();
                $('#hqTable').hide();
                $('#otherCompanyTable').hide();
            } else {
                 $.post("clientarea.php?action=productdetails&id={$id}&a=findEntityByNumber", 
                    {
                        "jurisdiction": $('#legalJurisdiction').val(),
                        "entityid": $('#legalEntity').val()
                    }, 
                    function(res) {
                        $('#verifiedData').show();
                        $('#verifiedEntity').text(res.response.result.name);
                        $("#entityname").val(res.response.result.name);
                        $('#verifiedID').text(res.response.result.company_number);
                        $("#entityid").val(res.response.result.company_number);
                        if(res.response.result.registered_address.region){
                            $("#entitystate").val(res.response.result.registered_address.region);
                            $('#verifiedState').text(res.response.result.registered_address.region);
                        }
                        if(res.response.result.registered_address.street_address){
                            $("#entityst").val(res.response.result.registered_address.street_address);
                            $('#verifiedStreet').text(res.response.result.registered_address.street_address);
                        }
                        if(res.response.result.registered_address.locality){
                            $("#entitycity").val(res.response.result.registered_address.locality);
                            $('#verifiedCity').text(res.response.result.registered_address.locality);
                        }
                        if(res.response.result.registered_address.postal_code){
                            $("#entitypc").val(res.response.result.registered_address.postal_code);
                            $('#verifiedPostalCode').text(res.response.result.registered_address.postal_code);
                        }
                        if(res.response.result.incorporation_date){
                            $('#verifiedDate').text(res.response.result.incorporation_date);
                        }
                        checkAllData()
                    }, 
                "json"); 
                $('#hqTable').show();
                $('#otherCompanyTable').show();
            }
        })


        $('#submitManually').on('click', function(){
            $('#legalEntityBox').hide();
            $('#legalEntityManual').show();
        })

        $('input[name^="entity"]').on('blur', function(){
            var allFilled = true;
            $('input[name^="entity"]').each(function(){
                if($(this).attr('id') != 'entitystate'){
                    if($(this).val() == ''){
                        allFilled = false;
                    }
                }
            })
            if(allFilled)
            {
                $('#verifiedData').show();
                $('#hqTable').show();
                $('#otherCompanyTable').show();
            } else {
                $('#verifiedData').hide();
                $('#hqTable').hide();
                $('#otherCompanyTable').hide();
            }

            switch($(this).attr('id')){
                case 'entityname':
                    $('#verifiedEntity').text($(this).val());
                break;
                case 'entityid':
                    $('#verifiedID').text($(this).val());
                break;
                case 'entitystate':
                    $('#verifiedState').text($(this).val());
                break;
                case 'entityst':
                    $('#verifiedStreet').text($(this).val());
                break;
                case 'entitycity':
                    $('#verifiedCity').text($(this).val());
                break;
                case 'entitypc':
                    $('#verifiedPostalCode').text($(this).val());
                break;
            }

            checkAllData();
        })

        $('#entityid').on('blur', function(){
            $('#confirmTransfer').val(0);
            $.post("clientarea.php?action=productdetails&id={$id}&a=findLei", 
                {
                    "company": $('#entityid').val(),
                }, 
                function(res) {
                    if(res.response.result.code == 1)
                    {
                        $('#detectedLei').show();
                        $('#confirmTransfer').val(0);
                    } else {
                        $('#detectedLei').hide();
                        $('#confirmTransfer').val(1);
                    }
                }, 
            "json"); 
        })

        $('#confirmImport').on('click', function(){
            $(this).attr('disabled', 'disabled')
            $('#confirmImportSpan').hide();
            $('#confirmedImport').show();
            checkAllData();
        })

        //headquarters and owners scripts
        $('#confirmHq').on('click', function(){
            $('#hqForm').hide();
            $(this).attr('disabled', 'disabled');
            $('#cancelHq').attr('disabled', false);
            $('#confirmOtherHq').val(0);
            checkAllData();
        })
        $('#cancelHq').on('click', function(){
            $('#hqForm').show();
            $(this).attr('disabled', 'disabled');
            $('#confirmHq').attr('disabled', false);
            $('#confirmOtherHq').val(1);
            checkAllData();
        })
        $('#confirmOtherCompany').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#cancelOtherCompany').attr('disabled', false);
            $('#isLevel2DataAvailable').val(1);
            $('#data2Consolidate').show();
            checkAllData();
        })

        $('#cancelOtherCompany').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#confirmOtherCompany').attr('disabled', false);
            $('#isLevel2DataAvailable').val(0);
            $('#isLevel2DataConsolidate').val(0);
            $('#isLevel2DataUltimate').val(0);
            $('#data2Consolidate').hide();
            $('#data2Ultimate').hide();
            $('.data2').attr('disabled', false);
            checkAllData();
        })

        $('#confirmConsolidate').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#cancelConsolidate').attr('disabled', false);
            $('#data2Ultimate').show();
            $('#isLevel2DataConsolidate').val(1);
            checkAllData();
        })

        $('#cancelConsolidate').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#confirmConsolidate').attr('disabled', false);
            $('#confirmUltimate').attr('disabled', false);
            $('#cancelUltimate').attr('disabled', false);
            $('#data2Ultimate').hide();
            $('#isLevel2DataConsolidate').val(0);
            $('#isLevel2DataUltimate').val(0);
            checkAllData();
        })

        $('#confirmUltimate').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#cancelUltimate').attr('disabled', false);
            $('#isLevel2DataUltimate').val(1);
            checkAllData();
        })

        $('#cancelUltimate').on('click', function(){
            $(this).attr('disabled', 'disabled');
            $('#confirmUltimate').attr('disabled', false);
            $('#isLevel2DataUltimate').val(0);
            checkAllData();
        })

        
        // create order
        $('#createOrder').on('click', function(){
            $('.orderProcessInfo').hide();
            $(this).attr('disabled', true);
            $('#createOrderConfirm').hide();
            $('#createOrderProcess').show();
            $.ajax({
                method: 'post',
                url: 'clientarea.php?action=productdetails&id={$id}&modop=custom&a=createOrder',
                dataType: 'json',
                data: {
                    "legalName" : $("#entityname").val(),
                    "registrationAuthorityEntityId" : $("#entityID").val(),
                    "legalID" : $("#entityid").val(),
                    "legalDropdown" : $("#legalEntityBox").is(":hidden"),
                    "legalJurisdiction" : $("#legalJurisdiction").val(),
                    "firstName" : $("#authorityFirstname").val(),
                    "lastName" : $("#authorityLastname").val(),
                    "legalfirstAddressLine" : $("#entityst").val(),
                    "legalPostal" : $("#entitypc").val(),
                    "legalCountry" : $("#legalJurisdiction").val().split('-')[0],
                    "legalCity" : $("#entitycity").val(),
                    "legalState" : $("#entitystate").val(),
                    "customHq" : $("#confirmOtherHq").val(),
                    "transfer" : $("#confirmTransfer").val(),
                    "isLevel2DataAvailable" : $('#isLevel2DataAvailable').val(),
                    "isLevel2DataConsolidate" : $('#isLevel2DataConsolidate').val(),
                    "isLevel2DataUltimate" : $('#isLevel2DataUltimate').val(),
                    "hqCity" : $("#entityname").val(),
                    "hqState" : $("#hqState").val(),
                    "hqCountry" : $("#hqCountry").val(),
                    "hqfirstAddressLine" : $("#hqfirstAddressLine").val(),
                    "hqPostal" : $("#hqPostal").val(),
                },
                success: function (data) {
                    $('#createOrderConfirm').show();
                    $('#createOrderProcess').hide();
                    if(data.response.result == 1)
                    {
                        $('#createOrderSuccess').show();
                        window.location.href="clientarea.php?action=productdetails&id={$id}&modop=custom&a=step2"
                    } else {
                        $('#createOrder').attr('disabled', false)
                        $('#createOrderError').text(data.response.error);
                        $('#createOrderError').show();
                        setTimeout(function(){
                            $('.orderProcessInfo').hide();
                        }, 4000);
                    }
                }
            });
        });


        $('#authorityFirstname').on('blur', function(){
            checkAllData();
        })
        $('#authorityLastname').on('blur', function(){
            checkAllData();
        })

        function checkAllData()
        {
            var allFilled = true;

            if($('input[name="entity[name]"]').is(":hidden") == false){
                $('input[name^="entity"]').each(function(){
                    if($(this).attr('id') != 'entitystate'){
                        if($(this).val() == ''){
                            allFilled = false;
                        }
                    }
                })
            }
            if($('#verifiedData').is(':hidden')){
                allFilled = false;   
            }
            if($('#confirmOtherHq').val() == ''){
                allFilled = false;    
            }
            if($('#confirmOtherHq').val() == ''){
                allFilled = false;
            }
            if($('#detectedLei').is(":hidden") == false){
                if($('#confirmTransfer').val() == 0){
                    allFilled = false;    
                }
            }
            if($('#authorityFirstname').val() == ''){
                allFilled = false;
            }
            if($('#authorityLastname').val() == ''){
                allFilled = false;
            }

            allFilled ? $('#createOrder').parent().show() : $('#createOrder').parent().hide()
        }
    })
</script>