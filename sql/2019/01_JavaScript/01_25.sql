#standardSQL
# 01_25: % of sites that ship sourcemaps.
SELECT
  client,
  COUNT(DISTINCT page) AS freq,
  total,
  ROUND(COUNT(DISTINCT page) * 100 / total, 2) AS pct
FROM
  `httparchive.almanac.summary_response_bodies`
JOIN
  (SELECT _TABLE_SUFFIX AS client, COUNT(0) AS total FROM `httparchive.summary_pages.2019_07_01_*` GROUP BY _TABLE_SUFFIX)
USING
  (client)
WHERE
  type = 'script' AND
  body LIKE '%sourceMappingURL%' AND
  NET.REG_DOMAIN(page) = NET.REG_DOMAIN(url)
GROUP BY
  client,
  total