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
