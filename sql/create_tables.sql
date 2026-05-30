CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    username TEXT NOT NULL,

    country TEXT,

    registration_date TIMESTAMP NOT NULL,

    birth_year INT,

    subscription_type TEXT CHECK (
        subscription_type IN ('free', 'premium')
    ),

    acquisition_channel TEXT
);

CREATE TABLE artists (
    artist_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    artist_name TEXT NOT NULL,

    genre TEXT,

    country TEXT
);

CREATE TABLE tracks (
    track_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    artist_id UUID REFERENCES artists(artist_id),

    track_name TEXT NOT NULL,

    duration_seconds INT,

    genre TEXT,

    release_year INT
);

CREATE TABLE listening_events (
    event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID REFERENCES users(user_id),

    track_id UUID REFERENCES tracks(track_id),

    listened_at TIMESTAMP NOT NULL,

    listen_duration INT,

    completed BOOLEAN,

    device_type TEXT,

    platform TEXT
);

CREATE TABLE subscriptions (
    subscription_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID REFERENCES users(user_id),

    plan_type TEXT,

    start_date TIMESTAMP,

    end_date TIMESTAMP,

    is_active BOOLEAN,

    payment_amount NUMERIC(10,2)
);

CREATE TABLE playlists (
    playlist_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID REFERENCES users(user_id),

    playlist_name TEXT,

    created_at TIMESTAMP
);

CREATE TABLE playlist_tracks (
    playlist_id UUID REFERENCES playlists(playlist_id),

    track_id UUID REFERENCES tracks(track_id),

    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE experiments (
    experiment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    experiment_name TEXT,

    group_name TEXT,

    user_id UUID REFERENCES users(user_id),

    assigned_at TIMESTAMP
);

CREATE INDEX idx_listening_user
ON listening_events(user_id);

CREATE INDEX idx_listening_track
ON listening_events(track_id);

CREATE INDEX idx_listening_time
ON listening_events(listened_at);

CREATE INDEX idx_subscription_user
ON subscriptions(user_id);

CREATE INDEX idx_experiments_user
ON experiments(user_id);