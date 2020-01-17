CREATE OR REPLACE FUNCTION postgisftw.us_grid(
	num_x integer DEFAULT 10,
	num_y integer DEFAULT 10,
	OUT id text,
	OUT geom geometry )
RETURNS SETOF record
AS $$
DECLARE
    lon_min CONSTANT numeric := -128;
    lon_max CONSTANT numeric := -64;
    lat_min CONSTANT numeric := 24;
    lat_max CONSTANT numeric := 49;
    dlon numeric;
    dlat numeric;
BEGIN
    dlon := (lon_max - lon_min) / num_x;
    dlat := (lat_max - lat_min) / num_y;
	RETURN QUERY
		SELECT
			x.x::text || '_' || y.y::text AS id,
			ST_MakeEnvelope(
                lon_min + (x.x - 1) * dlon, lat_min + (y.y - 1) * dlat,
                lon_min + x.x * dlon,       lat_min + y.y * dlat, 4326
             ) AS geom
		FROM generate_series(1, num_x) AS x(x)
        CROSS JOIN generate_series(1, num_y) AS y(y);
END;
$$
LANGUAGE 'plpgsql'
STABLE
STRICT;

SELECT * FROM postgisftw.us_grid();
