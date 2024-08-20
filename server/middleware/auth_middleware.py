from fastapi import Header,HTTPException
import jwt


def auth_middleware(x_auth_token = Header()):
    try:
        if not x_auth_token:
            raise HTTPException(401,'No Auth token, Access denied!')
        verifiedToken =  jwt.decode(x_auth_token,'password_key',['HS256'])
        print(verifiedToken)
        
        if not verifiedToken:
            raise HTTPException(401,'Token verification failed!')
        
        
        uid =  verifiedToken.get('id')
        return {'uid':uid,'token':x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401,'Token not valid!')
        