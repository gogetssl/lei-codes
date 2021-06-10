<?php

namespace LeiCodes\Lib;

use WHMCS\CustomField;

class CustomFieldModel extends CustomField
{
    protected $fillable = ['type', 'relid', 'fieldname', 'fieldtype', 'adminonly', 'description'];
}