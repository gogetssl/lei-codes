<?php

namespace LeiCodes\Lib;

use WHMCS\CustomField\CustomFieldValue;

class CustomFieldValueModel extends CustomFieldValue
{
    protected $fillable = ['fieldid', 'relid', 'value'];
}