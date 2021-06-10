<?php

namespace LeiCodes\Lib;

class CustomFieldRepository
{
    const LEICODE_ORDER_ID = 'lei_code_order_id';

    public static function getCustomField($name, $relid, $type)
    {
        return CustomFieldModel::where([
                ['fieldname', 'like', $name.'|%'],
                ['type', $type],
                ['relid', $relid]
            ])->first();
    }

    public static function saveOrderID($hosting_id, $packageId, $id)
    {
        $customFieldId = CustomFieldRepository::getCustomField(self::LEICODE_ORDER_ID, $packageId, 'product')->id;
        CustomFieldRepository::saveCustomFieldValue($customFieldId, $hosting_id, $id);
    }

    public static function saveCustomField($type, $relid, $fieldName, $fieldType, $adminOnly = 'on')
    {
        return CustomFieldModel::updateOrCreate(
            ['relid' => $relid, 'fieldname' => $fieldName],
            ['fieldtype' => $fieldType, 'type' => $type, 'adminonly' => $adminOnly]
        );
    }

    public static function saveCustomFieldValue($fieldid, $relid, $value)
    {
        return CustomFieldValueModel::updateOrCreate(
            ['fieldid' => $fieldid, 'relid' => $relid],
            ['value' => $value]
        );
    }

    public static function getCustomFieldValue($fieldid, $relid)
    {
        return CustomFieldValueModel::where('fieldid', $fieldid)
            ->where('relid', $relid)
            ->first();
    }

    public static function getCustomFieldValues($fields, $hosting_id)
    {
        return CustomFieldValueModel::whereIn('fieldid', $fields)
            ->where('relid', $hosting_id)
            ->first();
    }
}