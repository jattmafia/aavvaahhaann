// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
const NOTIFY_FN_URL = Deno.env.get('NOTIFY_FN_URL');


serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      SUPABASE_SERVICE_ROLE_KEY ?? '',
    )

    const dateTime = new Date();

    const from = new Date(dateTime.getTime());
    from.setMinutes(dateTime.getMinutes() - 5);

    const to = new Date(dateTime.getTime());
    to.setMinutes(dateTime.getMinutes() + 5);

    const { data, error } = await supabase.from('push_notifications').select('*').eq('active', true).gte('time', getUtcTimeString(from)).lte('time', getUtcTimeString(to))



    if (error) {
      throw new Error(error.message)
    }

    const dt = new Date();

    const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    const today = dt.toISOString().split('T')[0];


    console.log(today)
    const weekday = weekdays[dt.getDay()];

    console.log(weekday)

    const date = dt.getDate();






    console.log(data)
    console.log(today)

    const filteredData = data.filter((item) =>
      item.date === today
      || item.frequency === 'daily'
      ||
      (item.date === today && item.frequency === 'once')
      || (item.frequency === 'weekly' && item.weekday === weekday)
      || (item.frequency === 'monthly' && item.day === date)
    );

    console.log(filteredData)



    for (const notification of filteredData) {
      const response = await fetch(NOTIFY_FN_URL, {
        method: "POST",
        headers: {
          "Authorization": req.headers.get('Authorization')!,
          "Content-Type": 'application/json',
        },
        body: JSON.stringify(notification),
      })

      if (!response.ok) {
        throw new Error(`Failed to call notify function: ${response.status}`)
      }

      const responseBody = await response.json()

      await supabase.from('push_notifications').update({
        "results": [...notification.results, {
          "createdAt": new Date().toISOString(),
          "success": responseBody.success,
          "failure": responseBody.failure,
        }]
      }).eq('id', notification.id)
    }

    return new Response("Success", { status: 200 });



  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'

function getUtcTimeString(time) {
  // If time is not provided, use the current time
  time = time || new Date();

  // Convert to UTC and get ISO 8601 string with milliseconds
  const utcIsoString = time.toISOString();

  // Extract the time portion, including milliseconds
  const [, timeString] = utcIsoString.split('T');

  return timeString;
}