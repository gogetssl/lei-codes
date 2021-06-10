<?php

namespace LeiCodes\Lib;

use Illuminate\Database\Eloquent\Model as EloquentModel;

class LeiCodeOrderModel extends EloquentModel
{
    public $table = 'LeiCodes_Orders';
    public $fillable = [
        'hosting_id', 'order_id', 'sa_firstname', 'sa_lastname', 'entity_jurisdiction_code', 'entity_name', 'entity_id', 'entity_state',
        'entity_city', 'entity_postal_code', 'entity_street', 'entity_country', 'entity_date', 'transfer', 'parent_company', 'headquarters', 'hq_country',
        'hq_state', 'hq_street', 'hq_city', 'hq_postal', 'created_at'
    ];
    public $primaryKey = 'hosting_id';
    public $timestamps = false;

    public function service()
    {
        return $this->belongsTo("\WHMCS\Service\Service", "hosting_id");
    }
}