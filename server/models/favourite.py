from sqlalchemy import TEXT, Column, ForeignKey
from models.base import Base
from sqlalchemy.orm import relationship
class Favourite(Base):
    __tablename__ = "Favourites"
    
    id = Column(TEXT,primary_key= True)
    song_id = Column(TEXT,ForeignKey("songs.id"))
    user_id = Column(TEXT,ForeignKey("users.id"))
    
    song =  relationship('Song')
    