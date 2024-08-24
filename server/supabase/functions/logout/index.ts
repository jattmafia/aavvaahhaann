// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"


const FIREBASE_SERVER_KEY = Deno.env.get('FIREBASE_SERVER_KEY')


export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Authorization, X-Client-Info, Apikey, Content-Type',
}


export const handleCORS = (cb: (req: any) => Promise<Response>) => {
  return async (req) => {
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }
    const response = await cb(req);
    Object.entries(corsHeaders).forEach(([header, value]) => {
      response.headers.set(header, value);
    });
    return response;
  }
};


serve(handleCORS(async (req) => {
  const { token } = await req.json()

  const message = {
    registration_ids: [token],
    data: {
      type: 'logout',
    }
  }

  const response = await fetch("https://fcm.googleapis.com/fcm/send", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${FIREBASE_SERVER_KEY}`,
      "Content-Type": 'application/json',
    },
    body: JSON.stringify(message),
  })


  if (!response.ok) {
    throw new Error(`Failed to send Firebase push notification: ${response.status}`)
  }

  const body = await response.json()

  return new Response(
    JSON.stringify(body),
    { headers: { "Content-Type": "application/json" } },
  )
}))

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'

