<style>
.labelTd{
    font-weight: bold;
    width: 40%
}
</style>

{if $error}
   <div class="alert alert-danger text-center">{$error}</div>
{else}
    <h2 style="margin-bottom:20px">{$MGLANG.stepHeader}</h2>
    <div id="step2">
        <div class="alert alert-info">
            <table>
                <tr>
                    <td width="14%" style="text-align: center; font-size: 50px; vertical-align: middle !important;"><i class="fas fa-cog fa-spin"></i></td>
                    <td>
                        <b style="font-size:18px;">{$MGLANG.step3ConfirmationInfo}</b>
                        <p style="margin-top:10px;">{$MGLANG.step3ConfirmationInfoContent}</p>
                    </td>
                </tr>
            </table>
        </div>
<div class="row">
         <div class="col-sm-6">
               <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                  <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-clipboard-list"></i>&nbsp;{$MGLANG.H_MainDetails}</b></td></tr>
                  <tr>
                     <td class="labelTd" id="mainDetailsOrderStatus">{$MGLANG.orderStatus}</td><td id="orderStatus">{$order.status|ucfirst|replace:'_':' '}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="mainDetailsOrderID">{$MGLANG.orderID}</td><td id="orderID">{$order.lei_id}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="mainDetailsOrderPeriod">{$MGLANG.orderPeriod}</td><td id="orderPeriod">{$years}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="mainDetailsOrderPlaced">{$MGLANG.orderPlaced}</td><td id="orderPlaced">{$orderData.created_at}</td>
                  </tr>
               </table>
               <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                  <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-building"></i>&nbsp;{$MGLANG.H_LegalAddress}</b></td></tr>
                  <tr>
                     <td class="labelTd" id="legalAddressAddress">{$MGLANG.entityStreet}</td><td>{$orderData.entity_street}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressCity">{$MGLANG.entityCity}</td><td>{$orderData.entity_city}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderData.entity_postal_code}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressCountry">{$MGLANG.entityCountry}</td><td>
                           {foreach $countriesCodes as $countryName => $countryCode}
                              {if $countryCode == $orderData.entity_country}{$countryName}{/if}
                           {/foreach}
                     </td>
                  </tr>
               </table>
         </div>
         <div class="col-sm-6">
               <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                  <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-briefcase"></i>&nbsp;{$MGLANG.H_EntityDetails}</b></td></tr>
                  <tr>
                     <td class="labelTd" id="entityDetailsCompany">{$MGLANG.entityName}</td><td>{$orderData.entity_name}</td>
                  </tr>
                  {if $orderData.entity_date}
                    <tr>
                        <td class="labelTd" id="entityDetailsDate">{$MGLANG.incorporationDate}</td><td>{$orderData.entity_date}</td>
                    </tr>
                  {/if}
                     <tr>
                     <td class="labelTd" id="entityDetailsApprover">{$MGLANG.approver}</td><td>{$orderData.sa_firstname} {$orderData.sa_lastname}</td>
                  </tr>
               </table>
               {if $orderData->headquarters == 1}
               <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                  <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-city"></i>&nbsp;{$MGLANG.H_Headquarters}</b></td></tr>
                  <tr>
                     <td class="labelTd" id="hqAddress">{$MGLANG.entityStreet}</td><td>{$orderData.hq_street}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="hqCity">{$MGLANG.entityCity}</td><td>{$orderData.hq_city}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="hqPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderData.hq_postal}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="hqCountry">{$MGLANG.entityCountry}</td><td>{$orderData.hq_country}</td>
                  </tr>
               </table>
               {else}
                <table class="table table-striped table-bordered leitable" style="margin-top:20px;">
                  <tr class="text-center"><td colspan="2"><b style="font-size:18px;"><i class="fas fa-city"></i>&nbsp;{$MGLANG.H_Headquarters}</b></td></tr>
                  <tr>
                     <td class="labelTd" id="legalAddressAddress">{$MGLANG.entityStreet}</td><td>{$orderData.entity_street}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressCity">{$MGLANG.entityCity}</td><td>{$orderData.entity_city}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressPostalCode">{$MGLANG.entityPostalCode}</td><td>{$orderData.entity_postal_code}</td>
                  </tr>
                  <tr>
                     <td class="labelTd" id="legalAddressCountry">{$MGLANG.entityCountry}</td><td>
                           {foreach $countriesCodes as $countryName => $countryCode}
                              {if $countryCode == $orderData.entity_country}{$countryName}{/if}
                           {/foreach}
                     </td>
                  </tr>
               </table>
               {/if}
         </div>
      </div>


    
        <div class="alert alert-success confirminfo" id="successConfirm" style="display:none;">
            <table style="width:100%">
                <tr>
                    <td width="14%" style="text-align: center; font-size: 50px; vertical-align: middle !important;"><i class="fas fa-check-circle"></i></td>
                    <td>
                        <b style="font-size:18px;">{$MGLANG.orderFinalizationHeader}</b>
                        <p style="margin-top:10px;">{$MGLANG.orderFinalizationInfo}</p>
                    </td>
                </tr>
            </table>
        </div>

        <div class="alert alert-warning confirminfo" id="successCancel" style="display:none;">
            <table style="width:100%">
                <tr>
                    <td width="14%" style="text-align: center; font-size: 50px; vertical-align: middle !important;"><i class="fas fa-minus-circle"></i></td>
                    <td>
                        <b style="font-size:18px;">{$MGLANG.orderAbortionHeader}</b>
                        <p style="margin-top:10px;">{$MGLANG.orderAbortionInfo}</p>
                   </td>
                </tr>
            </table>
        </div>

        <div class="alert alert-danger confirminfo" id="errorProcess" style="display:none;">
            <table style="width:100%">
                <tr>
                    <td width="14%" style="text-align: center; font-size: 50px; vertical-align: middle !important;"><i class="fas fa-minus-circle"></i></td>
                    <td>
                        <b style="font-size:18px;">{$MGLANG.orderErrorHeader}</b>
                        <p id="errorText" style="margin-top:10px;"></p>
                    </td>
                </tr>
            </table>
        </div> 

        <p style="margin-top:10px;" class="text-center">
            <button style="width:140px; margin-right:5px;" class="btn btn-success confirmOrder" id="confirmOrder">
                <span id="confirmOrderProcess" style="display:none"><i class="fas fa-spinner fa-spin"></i>&nbsp{$MGLANG.Process}</span>
                <span id="confirmOrderConfirm">{$MGLANG.Confirm}</span>
            </button>
            <button style="width:140px;" class="btn btn-danger confirmOrder" id="cancelOrder">
                <span id="cancelOrderProcess" style="display:none"><i class="fas fa-spinner fa-spin"></i>&nbsp{$MGLANG.Process}</span>
                <span id="cancelOrderConfirm">{$MGLANG.Cancel}</span>
            </button>
        </p>

    </div>
{/if}
<script>
$(document).ready(function(){
   $('.confirmOrder').on('click', function(){
        $('.confirmOrder').attr('disabled', true);
        $('.confirminfo').hide();
        var confirm = $(this).attr('id');
        if(confirm == 'confirmOrder'){
            confirm = 1;
            $('#confirmOrderProcess').show();
            $('#confirmOrderConfirm').hide();
        } else {
            confirm = 0;
            $('#cancelOrderProcess').show();
            $('#cancelOrderConfirm').hide();
        }
        $.ajax({
            method: 'post',
            url: 'clientarea.php?action=productdetails&id={$id}&modop=custom&a=confirmOrder',
            dataType: 'json',
            data: {
                "confirm" : confirm,
            },
            success: function (data) {
                $('.confirmOrder').attr('disabled', false);
                if(data.response.result.confirm == 1)
                {
                    $('#successConfirm').show();   
                    $('#confirmOrderProcess').hide();
                    $('#confirmOrderConfirm').show();
                    setTimeout(function(){
                        window.location.href="clientarea.php?action=productdetails&id={$id}"
                    }, 4000)  
                } else if(data.response.result.confirm == 0){
                    $('#successCancel').show();
                    $('#cancelOrderProcess').hide();
                    $('#cancelOrderConfirm').show();
                    setTimeout(function(){
                        window.location.href="clientarea.php?action=productdetails&id={$id}"
                    }, 4000)         
                } else {
                    $('#confirmOrderProcess').hide();
                    $('#confirmOrderConfirm').show();
                    $('#cancelOrderProcess').hide();
                    $('#cancelOrderConfirm').show();  
                    $('#errorText').text(data.response.error);  
                    $('#errorProcess').show();  
                }
            }
        });
    })
      
})

</script>