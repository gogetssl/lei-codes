<h2 style="margin-bottom:20px">{$MGLANG.leiCodesDetails}</h2>
<style>
td,th{
    text-align:center;
}
th{
    width:220px;
}

</style>

{if $infostatus == 'none'}
    <div class="alert alert-info text-center">
        <p style="margin-top:10px;">{$MGLANG.step1Info}</p>
        <a style="margin-top:10px;" class="btn btn-primary" href="clientarea.php?action=productdetails&id={$id}&modop=custom&a=step1">{$MGLANG.configure}</a>
    </div>
{elseif $infostatus == 'step2'}
    <div class="alert alert-info text-center">
        <b style="font-size:18px;"><i class="fas fa-info-circle"></i>&nbsp;{$MGLANG.orderCheckInfoHeader}{$order.status|ucfirst|replace:'_':' '}</b>
        <p style="margin-top:10px;">{$infotext}</p>
        <a style="margin-top:10px;" class="btn btn-primary" href="clientarea.php?action=productdetails&id={$id}&modop=custom&a=step2">{$MGLANG.checkDetails}</a>
    </div>
{elseif $infostatus == 'step3'}
    <div class="alert alert-success text-center">
        <b style="font-size:18px;"><i class="fas fa-check-circle"></i>&nbsp;{$MGLANG.orderCheckInfoHeader}{$order.status|ucfirst|replace:'_':' '}</b>
        <p style="margin-top:10px;">{$infotext}</p>
        <a style="margin-top:10px;" class="btn btn-primary" href="clientarea.php?action=productdetails&id={$id}&modop=custom&a=step3">{if $order.status == 'need_action'}{$MGLANG.Confirm}{else}{$MGLANG.checkDetails}{/if}</a>
    </div>
{elseif $infostatus == 'unpaid' || $infostatus == 'rejected' || $infostatus == 'incomplete' || $infostatus == 'revoked' || $infostatus == 'cancelled'}
    <div class="alert alert-danger text-center">
        <b style="font-size:18px;"><i class="fas fa-minus-circle"></i>&nbsp;{$MGLANG.orderCheckInfoHeader}{$order.status|ucfirst|replace:'_':' '}</b>
        <p style="margin-top:10px;">{$infotext}</p>
    </div>
{elseif $infostatus == 'active' || $infostatus == 'expired'}

    {if $renew}
        {if $expiration}
            <div class="alert alert-danger confirminfo" id="renewInfo" >
                <b style="font-size:18px;"><i class="fas fa-minus-circle"></i>&nbsp;{$MGLANG.expiredInfo}</b>
            </div>
        {else}
            <div class="alert alert-warning confirminfo" id="renewInfo" >
                <b style="font-size:18px;"><i class="fas fa-minus-circle"></i>&nbsp;{$MGLANG.renewInfoHeader}</b>
                <p style="margin-top:10px;">{$MGLANG.renewInfoContent}</p>
                {if $invoicePaid === 2}
                    <p style="margin-top:10px;">{$MGLANG.renewInfoContentPaid}</p>
                {elseif $invoicePaid === 1}
                    <p style="margin-top:10px;">{$MGLANG.renewInfoContentUnpaid}</p>
                {else}
                    <p style="margin-top:10px;">{$MGLANG.renewInfoContentNotCreated}</p>
                {/if}
                <button style="margin-top:10px;" id="openRenewModal" class="btn btn-primary">{$MGLANG.RenewOrder}</button>
            </div>

            <div class="modal fade in" id="renewalModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" style="display: none; padding-right: 12px; background-color: rgba(0,0,0, 0.5);">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                            <h4 class="modal-title" id="myModalLabel1">{$MGLANG.confirmRenewHeader}</h4>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-info">
                                {$MGLANG.questionToRenew}
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="alert alert-success confirmInfo" id="successConfirmPaid" style="display:none; margin:15px; text-align:center;">
                                {$MGLANG.successConfirmPaid}
                            </div>
                            <div class="alert alert-warning confirmInfo" id="successConfirmUnpaid" style="display:none; margin:15px; text-align:center;">
                                {$MGLANG.successConfirmUnpaid}
                            </div>
                            <div class="alert alert-danger confirmInfo" id="errorConfirm" style="display:none; margin:15px; text-align:center;">
                                
                            </div>

                            <button class="btn btn-primary" type="button" id="renewConfirmed">
                                <span id="renewConfirmProcess" style="display:none"><i class="fas fa-spinner fa-spin"></i>&nbsp;{$MGLANG.Process}</span>
                                <span id="renewConfirmConfirm">{$MGLANG.Confirm}</span>
                            </button>
                            <button type="button" class="btn btn-default back" data-dismiss="modal"><i class='far fa-arrow-alt-circle-left'></i>&nbspBack</button>
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    {/if}

    {if $infostatus == 'active'}
        <div class="row">
            <div class="col-sm-6">
                <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-clipboard-list"></i>&nbsp;{$MGLANG.H_MainDetails}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="mainDetailsOrderStatus">{$MGLANG.orderStatus}</td><td id="orderStatus">{$order.status|ucfirst}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="mainDetailsOrderID">{$MGLANG.orderID}</td><td id="orderID">{$order.lei_id}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="mainDetailsOrderPeriod">{$MGLANG.orderPeriod}</td><td id="orderPeriod">{$years}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="mainDetailsOrderPlaced">{$MGLANG.orderPlaced}</td><td id="orderPlaced">{$dbOrder.created_at}</td>
                    </tr>
                </table>
                <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-building"></i>&nbsp;{$MGLANG.H_LegalAddress}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="legalAddressAddress">{$MGLANG.entityStreet}</td><td>{$orderDetails.legalfirstAddressLine}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressCity">{$MGLANG.entityCity}</td><td>{$orderDetails.legalCity}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderDetails.legalPostal}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressCountry">{$MGLANG.entityCountry}</td><td>
                            {foreach $countriesCodes as $countryName => $countryCode}
                                {if $countryCode == $orderDetails.legalCountry}{$countryName}{/if}
                            {/foreach}
                        </td>
                    </tr>
                </table>
            </div>
            <div class="col-sm-6">
                    <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-file-alt"></i>&nbsp;{$MGLANG.H_LeiDetails}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="entityDetailsCompany">{$MGLANG.leiCode}</td><td>{$order.lei_number}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="entityDetailsDate">{$MGLANG.validFrom}</td><td>{$order.valid_from}</td>
                    </tr>
                        <tr>
                        <td class="labelTd" id="entityDetailsApprover">{$MGLANG.validTill}</td><td>{$order.valid_till}</td>
                    </tr>
                </table>
                <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-briefcase"></i>&nbsp;{$MGLANG.H_EntityDetails}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="entityDetailsCompany">{$MGLANG.entityName}</td><td>{$dbOrder.entity_name}</td>
                    </tr>
                    {if $dbOrder.entity_date}
                        <tr>
                            <td class="labelTd" id="entityDetailsDate">{$MGLANG.incorporationDate}</td><td>{$dbOrder.entity_date}</td>
                        </tr>
                    {/if}
                        <tr>
                        <td class="labelTd" id="entityDetailsApprover">{$MGLANG.approver}</td><td>{$dbOrder.sa_firstname} {$dbOrder.sa_lastname}</td>
                    </tr>
                </table>
                {if $orderData->hqCity}
                <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-city"></i>&nbsp;{$MGLANG.H_Headquarters}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="hqAddress">{$MGLANG.entityStreet}</td><td>{$orderDetails.hqfirstAddressLine}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="hqCity">{$MGLANG.entityCity}</td><td>{$orderDetails.hqCity}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="hqPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderDetails.hqPostal}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="hqCountry">{$MGLANG.entityCountry}</td><td>{$orderDetails.hqCountry}</td>
                    </tr>
                </table>
                {else}
                    <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                    <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-city"></i>&nbsp;{$MGLANG.H_Headquarters}</b></td></tr>
                    <tr>
                        <td class="labelTd" id="legalAddressAddress">{$MGLANG.entityStreet}</td><td>{$orderDetails.legalfirstAddressLine}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressCity">{$MGLANG.entityCity}</td><td>{$orderDetails.legalCity}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderDetails.legalPostal}</td>
                    </tr>
                    <tr>
                        <td class="labelTd" id="legalAddressCountry">{$MGLANG.entityCountry}</td><td>
                            {foreach $countriesCodes as $countryName => $countryCode}
                                {if $countryCode == $orderDetails.legalCountry}{$countryName}{/if}
                            {/foreach}
                        </td>
                    </tr>
                </table>
                {/if}
            </div>
        </div>
    {/if}
{else}

{/if}

<script>
    $(document).ready(function(){
        $('#openRenewModal').on('click', function(){
            $('#renewalModal').show();
        })
        $(document).on('click', "span:contains('x')", function(){
            $('.modal').hide();
        });
        $(document).on('click', "button[data-dismiss='modal']", function(){
            $('.modal').hide();
        });

        $('#renewConfirmed').on('click', function(){
            $('.confirmInfo').hide();
            $(this).attr('disabled', true);
            $('#renewConfirmProcess').hide();
            $('#renewConfirmConfirm').show();
            $.ajax({
                method: 'post',
                url: 'clientarea.php?action=productdetails&id={$id}&modop=custom&a=confirmRenewal',
                dataType: 'json',
                data: {
                    "confirm" : 1,
                },
                success: function (data) {
                    $('.renewConfirmed').attr('disabled', false);
                
                    $('#renewConfirmProcess').hide();
                    $('#renewConfirmConfirm').show();
                    if(data.response.result){
                        if(data.response.result.confirm == 1)
                        { 
                            $('#successConfirmPaid').show();   
                        } else {
                            $('#successConfirmUnpaid').show(); 
                        }
                        setTimeout(function(){
                            window.location.href="clientarea.php?action=productdetails&id={$id}"
                        }, 4000)  
                    } else {
                        $('#resendEmailError').text(data.response.error)
                        $('#errorConfirm').show();   
                    }

                }
            });
        })

    });
</script>