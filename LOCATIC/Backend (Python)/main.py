from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from BaseModels import EventList, Event
app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

database = [{
            "name": "Samgatha", "join_count": 1500, "start_date": "29-10-2023", "end_date": "31-10-2023"
            },
            {"name": "Convocation", "join_count": 200,
             "start_date": "29-10-2023", "end_date": "31-10-2023"},
            {"name": "Meraki", "join_count": 500, "start_date": "29-10-2023", "end_date": "31-10-2023"}]


@app.get("/events", response_model=EventList)
def generate_events(filter: str):
    if filter == "all":
        return {"events": database}
    elif filter == "past":
        return {"events": database[0:1]}
    elif filter == "ongoing":
        return {"events": database[0:0]}
    elif filter == "upcoming":
        return {"events": database[1:]}
    else:
        raise HTTPException(
            status_code=status.HTTP_421_MISDIRECTED_REQUEST, detail="Invalid Filter")
