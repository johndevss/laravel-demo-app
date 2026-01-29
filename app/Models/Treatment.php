<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;


class Treatment extends Model
{
    protected $casts = [
        'price' => \App\Casts\MoneyCast::class,
    ];
    public function patient(): BelongsTo
    {
        return $this->belongsTo(Patient::class);
    }
}