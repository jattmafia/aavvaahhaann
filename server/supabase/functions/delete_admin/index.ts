// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');


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



serve( handleCORS(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      SUPABASE_SERVICE_ROLE_KEY ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )


    const params = await req.json()


    const { data, error } = await supabase.auth.admin.deleteUser(
      params.uid
    )



    if (error) {
      throw error
    }

    await supabase.from('admins').delete().eq('id', params.id)

    return new Response("Success", { status: 200 });

   
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
}))
