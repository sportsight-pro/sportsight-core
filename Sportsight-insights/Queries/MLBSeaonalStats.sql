SELECT
  *,
  DENSE_RANK() OVER (PARTITION BY LeagueCode, SeasonCode, StatName ORDER BY StatValue DESC) AS DenseRank
FROM (
  SELECT
    '{SportCode}' AS SportCode,
    '{StatSource}' AS StatSource,
    '{StatFunction}' AS StatFunction,
    '{StatObject}' AS StatObject,
    '{StatTimeframe}' AS StatTimeframe,
    '{LeagueCode}' AS LeagueCode,
    Season AS SeasonCode,
    'N/A' as CompetitionStageCode,
    'N/A' as CompetitionDay,
    'N/A' AS MatchCode,
    'N/A' as MatchStageCode,
    CAST(team.id AS STRING) AS TeamCode,
    CAST({PlayerCode} AS STRING) AS PlayerCode,
    '{StatName}' AS StatName,
    ROUND(stats.{StatName},2) AS StatValue,
    Count(1) as Count,
    "strikeouts Per 9 Innings" as Description
  FROM
    `sportsight-tests.Baseball1.seasonal_{StatObject}_stats`
  LEFT JOIN
    unnest ( Seasondata.{StatObject}StatsTotals )
  GROUP BY
    LeagueCode,
    SeasonCode,
    CompetitionStageCode,
    CompetitionDay,
    MatchCode,
    MatchStageCode,
    teamCode,
    playerCode,
    StatName,
    StatValue
    ) WHERE StatValue is not NULL and StatValue > 0
