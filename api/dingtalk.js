module.exports = async (req, res) => {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') {
    return res.status(405).json({ errcode: -1, errmsg: 'Method Not Allowed' });
  }

  const DINGTALK_URL = 'https://oapi.dingtalk.com/robot/send?access_token=0aae4ea4b8f0426f91fe97181b97353763e8902795b4a4991d58b39996c5cbd7';

  try {
    // 手动解析 body（Vercel api/ 目录不会自动解析）
    let body = '';
    for await (const chunk of req) body += chunk;
    const payload = JSON.parse(body || '{}');

    const response = await fetch(DINGTALK_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });
    const result = await response.json();
    return res.status(200).json(result);
  } catch (err) {
    return res.status(500).json({ errcode: -1, errmsg: err.message });
  }
};
