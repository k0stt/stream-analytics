import pandas as pd
import numpy as np

from faker import Faker
from sqlalchemy import create_engine
from dotenv import load_dotenv

import uuid
import random
import os

from datetime import datetime, timedelta
#подключение
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

DATABASE_URL = (
    f"postgresql://{DB_USER}:{DB_PASSWORD}"
    f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

engine = create_engine(DATABASE_URL)

fake = Faker()

#генерация USERS

NUM_USERS = 10000

countries = [
    "USA",
    "Germany",
    "France",
    "UK",
    "Canada",
    "Brazil",
    "Japan"
]

acquisition_channels = [
    "TikTok Ads",
    "Instagram Ads",
    "Organic",
    "YouTube Ads",
    "Referral"
]

subscription_types = ["free", "premium"]

users = []

for _ in range(NUM_USERS):

    registration_date = fake.date_time_between(
        start_date="-1y",
        end_date="now"
    )

    subscription = np.random.choice(
        subscription_types,
        p=[0.7, 0.3]
    )

    users.append({
        "user_id": str(uuid.uuid4()),
        "username": fake.user_name(),

        "country": random.choice(countries),

        "registration_date": registration_date,

        "birth_year": random.randint(1970, 2010),

        "subscription_type": subscription,

        "acquisition_channel": random.choice(
            acquisition_channels
        )
    })

users_df = pd.DataFrame(users)

#ARTISTS

genres = [
    "Pop",
    "Rock",
    "Hip-Hop",
    "Jazz",
    "Electronic",
    "Classical"
]

artists = []

for _ in range(300):

    artists.append({
        "artist_id": str(uuid.uuid4()),

        "artist_name": fake.name(),

        "genre": random.choice(genres),

        "country": random.choice(countries)
    })

artists_df = pd.DataFrame(artists)

#TRACKS

tracks = []

for _, artist in artists_df.iterrows():

    num_tracks = random.randint(5, 20)

    for _ in range(num_tracks):

        tracks.append({
            "track_id": str(uuid.uuid4()),

            "artist_id": artist["artist_id"],

            "track_name": fake.sentence(nb_words=3),

            "duration_seconds": random.randint(120, 320),

            "genre": artist["genre"],

            "release_year": random.randint(2000, 2025)
        })

tracks_df = pd.DataFrame(tracks)

#listening_events

events = []

platforms = [
    "iOS",
    "Android",
    "Web"
]

devices = [
    "Mobile",
    "Desktop",
    "Tablet"
]

for _, user in users_df.iterrows():

    # активность пользователя
    activity_level = np.random.choice(
        ["low", "medium", "high"],
        p=[0.5, 0.35, 0.15]
    )

    if activity_level == "low":
        num_events = random.randint(5, 30)

    elif activity_level == "medium":
        num_events = random.randint(31, 120)

    else:
        num_events = random.randint(121, 400)

    for _ in range(num_events):

        track = tracks_df.sample(1).iloc[0]

        listened_at = fake.date_time_between(
            start_date=user["registration_date"],
            end_date="now"
        )

        listen_duration = random.randint(
            20,
            track["duration_seconds"]
        )

        completed = (
            listen_duration >
            track["duration_seconds"] * 0.8
        )

        events.append({
            "event_id": str(uuid.uuid4()),

            "user_id": user["user_id"],

            "track_id": track["track_id"],

            "listened_at": listened_at,

            "listen_duration": listen_duration,

            "completed": completed,

            "device_type": random.choice(devices),

            "platform": random.choice(platforms)
        })

events_df = pd.DataFrame(events)

# SUBSCRIPTIONS

subscriptions = []

premium_users = users_df[
    users_df["subscription_type"] == "premium"
]

for _, user in premium_users.iterrows():

    start_date = fake.date_time_between(
        start_date=user["registration_date"],
        end_date="now"
    )

    is_active = np.random.choice(
        [True, False],
        p=[0.8, 0.2]
    )

    end_date = None

    if not is_active:
        end_date = start_date + timedelta(days=30)

    subscriptions.append({
        "subscription_id": str(uuid.uuid4()),

        "user_id": user["user_id"],

        "plan_type": "premium_monthly",

        "start_date": start_date,

        "end_date": end_date,

        "is_active": is_active,

        "payment_amount": 9.99
    })

subscriptions_df = pd.DataFrame(subscriptions)

#генерация A/B теста новый алгоритм рекомендаций

experiments = []

sample_users = users_df.sample(4000)

for _, user in sample_users.iterrows():

    group = random.choice(["control", "test"])

    experiments.append({
        "experiment_id": str(uuid.uuid4()),

        "experiment_name": "new_recommendation_algorithm",

        "group_name": group,

        "user_id": user["user_id"],

        "assigned_at": fake.date_time_between(
            start_date="-90d",
            end_date="now"
        )
    })

experiments_df = pd.DataFrame(experiments)

#загружаем в дб

users_df.to_sql(
    "users",
    engine,
    if_exists="append",
    index=False
)

artists_df.to_sql(
    "artists",
    engine,
    if_exists="append",
    index=False
)

tracks_df.to_sql(
    "tracks",
    engine,
    if_exists="append",
    index=False
)

events_df.to_sql(
    "listening_events",
    engine,
    if_exists="append",
    index=False
)

subscriptions_df.to_sql(
    "subscriptions",
    engine,
    if_exists="append",
    index=False
)

experiments_df.to_sql(
    "experiments",
    engine,
    if_exists="append",
    index=False
)

print("users:", len(users_df))
print("artists:", len(artists_df))
print("tracks:", len(tracks_df))
print("listening events:", len(events_df))
print("subscriptions:", len(subscriptions_df))
print("experiments:", len(experiments_df))

