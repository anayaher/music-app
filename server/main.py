from fastapi import FastAPI, HTTPException, Request
import uuid
import bcrypt
from models.base import Base
from routes import auth
from database import engine
from routes import song

app = FastAPI()
app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')

Base.metadata.create_all(engine)