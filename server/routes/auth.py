
import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_shcemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session,joinedload
import jwt

from pydantic_shcemas.user_login import userLogin


router = APIRouter()


@router.post('/signup',status_code=201)
def signup_user(user:UserCreate,db:Session=Depends(get_db)):
   
    
    #extract data from req
    
    #check if user exists in db
    user_db =  db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(400,'User with same email already exists!')
       
    
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    
    user_db = User(id=str(uuid.uuid4()),email = user.email,password = hashed_pw,name = user.name)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db


#login route
@router.post('/login')
def login_user(user:userLogin,db:Session = Depends(get_db)):
    #check already exists or not
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(400,'Account with this email does not exist!')
    password = bcrypt.checkpw(user.password.encode(),user_db.password)
    if not password:
        raise HTTPException(400,'Incorrect Password')
    
    token = jwt.encode({'id':user_db.id},'password_key');
    
    return{'token':token,'user':user_db};
    
@router.get('/')
def get_user_data(db:Session = Depends(get_db),
                  user_dict = Depends(auth_middleware),):
   user  =  db.query(User).filter(User.id == user_dict['uid']).options(joinedload(User.favourites)).first()
   
   if not user:
       raise HTTPException(404,'User Not Found!')
   return user
   
    
        
    