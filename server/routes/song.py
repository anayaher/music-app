
import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile

import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url


from database import get_db
from middleware.auth_middleware import auth_middleware
from models.favourite import Favourite
from models.songs import Song
from pydantic_shcemas.fav_song import FavSong
router  = APIRouter()
from sqlalchemy.orm import joinedload
from sqlalchemy.orm import session


# Configuration       
cloudinary.config( 
    cloud_name = "dfzqnwuf3", 
    api_key = "217786281343952", 
    api_secret = "BiKZxvPeEsoL4fVb9kQjgnfi0Fc", # Click 'View Credentials' below to copy your API secret
    secure=True
)




@router.get('/list/favourites')
def list_fav_songs(db:session = Depends(get_db),auth_dict = Depends(auth_middleware)):
    user_id  = auth_dict['uid']
    fav_songs =  db.query(Favourite).filter(Favourite.user_id == user_id).options(
        joinedload(Favourite.song)).all()
    return fav_songs
    
    

@router.post('/favourite',status_code=200)
def favourite_song(song:FavSong,db:session = Depends(get_db),auth_dict = Depends(auth_middleware)):
    
    #song is already Favourited
    user_id = auth_dict['uid']
    fav_song = db.query(Favourite).filter(Favourite.song_id == song.song_id,Favourite.user_id == user_id).first()
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return{'message':False}
    else:
       new_fav = Favourite(id = str(uuid.uuid4()),song_id = song.song_id,user_id = user_id)
       db.add(new_fav)
       db.commit()
       return{'message':True}

@router.post('/upload',status_code=201)
def upload_song(song:UploadFile = File(...),thumbnail:UploadFile = File(...),artist= Form(...),
                song_name = Form(...),hex_code= Form(...),db:session = Depends(get_db),auth_dict = Depends(auth_middleware)):
    
    song_id  = str(uuid.uuid4())
    song_res  =  cloudinary.uploader.upload(song.file,resource_type = 'auto',folder = f'songs/{song_id}')
   
    thumb_res = cloudinary.uploader.upload(thumbnail.file,resource_type = 'image',folder= f'songs/{song_id}')
   
    new_song = Song(
        id = song_id,
        song_name = song_name,
        artist = artist,
        hex_code = hex_code,
        song_url = song_res['url'],
        thumbnail_url = thumb_res['url'],    )
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list',status_code= 200)
def list_song(db:session = Depends(get_db),
              auth_dict = Depends(auth_middleware)):
   songs  =   db.query(Song).all()
   
  
   return songs