export default {
  async fetch(request) {
    const url = new URL(request.url);
    const userId = url.searchParams.get("userId");
    const tokenFromLinkvertise = url.searchParams.get("token");
    const mySecretToken = "d170e738ccf12db413070f213b9c1cc25"; 

    if (!userId) {
      return new Response("Missing UserID.", { status: 400 });
    }

    if (tokenFromLinkvertise !== mySecretToken) {
        return new Response("⛔ Bypass Detected!", { status: 403 });
    }

    const cache = caches.default;
    const cacheKey = new Request("https://ratelimit/" + userId);
    
    let cachedResponse = await cache.match(cacheKey);
    if (cachedResponse) {
      return new Response("Wait 5 minutes.", { status: 429 });
    }
    
    await cache.put(cacheKey, new Response("Limited", { headers: { "Cache-Control": "max-age=300" } }));

    const rawKey = userId + "SLAP_AURA_SECRET_2025_MAJED";
    const encoder = new TextEncoder();
    const hashBuffer = await crypto.subtle.digest('SHA-256', encoder.encode(rawKey));
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');

    return new Response("SA-" + hashHex.substring(0, 16).toUpperCase(), {
      headers: { "Content-Type": "text/plain" }
    });
  }
};