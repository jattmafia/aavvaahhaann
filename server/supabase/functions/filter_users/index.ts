// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders, handleCORS } from '../_shared/cors.ts'


serve(handleCORS( async (req) => {
  const { ageMin, ageMax, gender, lang, country, state, city, premium, expired, birthday, channel } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
  )

  console.log('started')

  var query = supabase.from('users').select()


  if (channel !== undefined && channel != null) {
    query = query.eq('channel', channel)
  }

  if (ageMin !== undefined && ageMin != null ) {
    console.log(ageMin);
    const dobGt = new Date();
    dobGt.setFullYear(dobGt.getFullYear() - ageMin);
    dobGt.setHours(0, 0, 0, 0);
    console.log(dobGt.toISOString()); // Set time components to zero
    query = query.lt('dateOfBirth', dobGt.toISOString());
  }

  if (ageMax !== undefined && ageMax !== null) {
    console.log(ageMax);
    const dobLt = new Date();
    dobLt.setFullYear(dobLt.getFullYear() - ageMax - 1);
    dobLt.setHours(23, 59, 59, 999); // Set time components to the end of the day
    console.log(dobLt.toISOString());
    query = query.gt('dateOfBirth', dobLt.toISOString());
  }
  if (gender !== undefined && gender !== null) {
    query = query.eq('gender', gender)
  }
  if (lang !== undefined && lang !== null) {
    query = query.eq('lang', lang)
  }
  if (country !== undefined && country !== null) {
    query = query.eq('country', country)
  }
  if (state !== undefined && state !== null) {
    query = query.eq('state', state)
  }
  if (city !== undefined && city !== null) {
    query = query.eq('city', city)
  }
  if (premium !== undefined && premium !== null) {
    query = query.eq('premium', premium)
  }
  if (expired !== undefined && expired !== null) {
    query = expired ? query.lt('expiryAt', new Date().toISOString()) : query.gt('expiryAt', new Date().toISOString())
  }

  const { data, error } = await query

  console.log(data);

  if (error) {
    throw error
  }

  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  )
}))

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'




