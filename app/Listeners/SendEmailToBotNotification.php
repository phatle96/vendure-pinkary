<?php

namespace App\Listeners;

use Illuminate\Mail\Events\MessageSent;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Http;

class SendEmailToBotNotification
{
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(MessageSent $event): void
    {
        $botURL = env('BOT_URL');
        $response = Http::post($botURL.'/api/save-email', [
            'emailAddress' => $event->message->getTo()['0']->getAddress(),
            'content' => $event->message->getTextBody()
        ]);
    }
}
