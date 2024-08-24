// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
// import { handleCORS } from '../_shared/cors.ts'


const FIREBASE_SERVER_KEY = Deno.env.get('FIREBASE_SERVER_KEY')


console.log('FIREBASE_SERVER_KEY', FIREBASE_SERVER_KEY)


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
  const push = await req.json()

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      // { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    if (push.topic !== null && push.topic !== undefined) {
      const response = await pushNotify(push.title, push.body, push.image, undefined, push.topic, push.type, push.ids, push.link)
      return new Response(JSON.stringify(response), { status: 200 })
    } else if (push.users !== null && push.users !== undefined) {
      const { data: users, error } = await supabase
        .from('users')
        .select('fcmToken')
        .in('id', push.users)

      if (error) {
        throw error
      }

      const tokens = users?.map(t => t.fcmToken).filter(token => token !== null && token !== undefined) ?? [] as string[]

      const response = await pushNotify(push.title, push.body, push.image, tokens, undefined, push.type, push.ids, push.link)
      return new Response(JSON.stringify(response), { status: 200 })
    } else {

      var query = supabase.from('users').select('fcmToken')

      if (push.channel !== undefined && push.channel != null) {
        query = query.eq('channel', push.channel)
      }

      if (push.ageMin !== undefined && push.ageMin != null) {
        const dobGt = new Date();
        dobGt.setFullYear(dobGt.getFullYear() - push.ageMin);
        dobGt.setHours(0, 0, 0, 0);
        console.log(dobGt.toISOString()); // Set time components to zero
        query = query.lt('dateOfBirth', dobGt.toISOString());
      }

      if (push.ageMax !== undefined && push.ageMax !== null) {
        const dobLt = new Date();
        dobLt.setFullYear(dobLt.getFullYear() - push.ageMax - 1);
        dobLt.setHours(23, 59, 59, 999); // Set time components to the end of the day
        console.log(dobLt.toISOString());
        query = query.gt('dateOfBirth', dobLt.toISOString());
      }
      if (push.gender !== undefined && push.gender !== null) {
        query = query.eq('gender', push.gender)
      }
      if (push.lang !== undefined && push.lang !== null) {
        query = query.eq('lang', push.lang)
      }
      if (push.country !== undefined && push.country !== null) {
        query = query.eq('country', push.country)
      }
      if (push.state !== undefined && push.state !== null) {
        query = query.eq('state', push.state)
      }
      if (push.city !== undefined && push.city !== null) {
        query = query.eq('city', push.city)
      }
      if (push.premium !== undefined && push.premium !== null) {
        query = query.eq('premium', push.premium).neq('lifetime', true)
      }
      if (push.expired !== undefined && push.expired !== null) {
        query = push.expired ? query.lt('expiryAt', new Date().toISOString()) : query.gt('expiryAt', new Date().toISOString())
      }

      const { data, error } = await query

      if (error) {
        throw error
      }

      const tokens = data?.map(t => t.fcmToken)?.filter(token => token !== null && token !== undefined) ?? [] as string[]

      const response = await pushNotify(push.title, push.body, push.image, tokens, undefined, push.type, push.ids, push.link)
      return new Response(JSON.stringify(response), { status: 200 })
    }
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
}))


async function pushNotify(title: string, body: string, image?: string, tokens?: string[], topic?: string, type?: string, ids?: string[], link?: string) {
  const notification = {
    title: title,
    body: body,
    image: image,
  }

  if (tokens != undefined) {


    let success = 0;

    let failure = 0;


    while (tokens.length > 0) {
      const group = tokens.splice(0, 500);

      const message = {
        notification: notification,
        registration_ids: group,
        data: {
          type: type,
          ids: ids,
          link: link,
          "content-available": true

        },
        content_available: true,
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
              "content-available": 1
            },
          },
          headers: {
            "apns-push-type": "background",
            "apns-priority": "5",
            "apns-topic": "io.flutter.plugins.firebase.messaging",
          },
        },
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

      const data = await response.json()

      success = success + data.success
      failure = failure + data.failure

    }

    return {
      success: success,
      failure: failure,
    }

  } else {
    const message = {
      notification: notification,
      to: topic !== undefined ? `/topics/${topic}` : null,
      data: {
        type: type,
        ids: ids,
        link: link,
        "content-available": 1
      },
      content_available: true,
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
            "content-available": true,
          },
        },
        headers: {
          "apns-push-type": "background",
          "apns-priority": "5",
          "apns-topic": "io.flutter.plugins.firebase.messaging",
        },
      },

    }

    console.log(message);

    // Send the request to the Firebase push notification API.
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

    const responseBody = await response.json()

    return responseBody
  }
}


//// Password
//// Client first name
//// Name of organizational unit
//// Organization name
//// City/locality
//// State/province
//// Country code
////

