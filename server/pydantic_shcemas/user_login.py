from pydantic import BaseModel


class userLogin(BaseModel):
    email:str
    password:str