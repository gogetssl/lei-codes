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
                     <b style="font-size:18px;">{$MGLANG.stepHeader}</b>
                     <p style="margin-top:10px;">{$MGLANG.step2process}</p>
                     <b style="margin-top:10px;"><i class="fas fa-clock"></i>&nbsp;{$waitingInfo}</b>
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
   </div>

{/if}

<script>
$(document).ready(function(){
   setInterval(function(){
      $.ajax({
         method: 'post',
         url: 'clientarea.php?action=productdetails&id={$id}&modop=custom&a=checkOrderStatus',
         dataType: 'json',
         data: {
            "process" : 1,
         },
         success: function (data) {
            if(data.response.result == 1)
            {
               window.location.href="clientarea.php?action=productdetails&id={$id}&modop=custom&a=step3"
            } 
         }
      });
   }, 60000)
})

</script>