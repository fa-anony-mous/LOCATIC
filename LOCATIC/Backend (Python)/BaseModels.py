from pydantic import BaseModel


class Event(BaseModel):
    name: str
    join_count: int
    start_date: str
    end_date: str


class EventList(BaseModel):
    events: list[Event] | None
