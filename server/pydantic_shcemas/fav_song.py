from pydantic import BaseModel


class FavSong(BaseModel):
    song_id:str