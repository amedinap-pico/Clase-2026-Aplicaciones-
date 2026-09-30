import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from supabase import create_client

load_dotenv()

app = FastAPI(title="API de usuarios USFQ")


def crear_cliente_supabase():
    """Lee la clave al atender solicitudes, para que /docs abra sin ella."""
    url = os.environ.get("SUPABASE_URL")
    secret = os.environ.get("SUPABASE_SECRET")
    if not url or not secret:
        raise HTTPException(
            status_code=503,
            detail="Configura SUPABASE_URL y SUPABASE_SECRET en api_usuarios/.env",
        )
    # Esta clave de privilegios elevados vive solo en este servidor.
    return create_client(url, secret)


class NuevoUsuario(BaseModel):
    correo: str
    clave: str
    nombre: str


@app.post("/usuarios")
def crear_usuario(u: NuevoUsuario):
    supabase = crear_cliente_supabase()
    usuario = None
    try:
        resultado = supabase.auth.admin.create_user(
            {"email": u.correo, "password": u.clave, "email_confirm": True}
        )
        usuario = resultado.user
        if usuario is None:
            raise RuntimeError("Supabase no devolvió el usuario creado.")
        supabase.table("perfiles").insert(
            {"id": usuario.id, "nombre": u.nombre}
        ).execute()
        return {"ok": True, "id": usuario.id}
    except Exception as exc:
        # Evita dejar una cuenta huérfana si falla la inserción del perfil.
        if usuario is not None:
            try:
                supabase.auth.admin.delete_user(usuario.id)
            except Exception:
                pass
        raise HTTPException(status_code=400, detail=str(exc)) from exc
