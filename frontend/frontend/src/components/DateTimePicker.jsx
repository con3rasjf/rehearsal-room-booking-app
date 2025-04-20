import React, { useState, useEffect } from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import '../index.css';

const fetchOccupiedSlots = async () => {
  const response = await fetch("http://api.local/reservas/");
  const data = await response.json();
  const slots = {};

  data.forEach(({ sala, fecha, duracion }) => {
    const date = fecha.split("T")[0];
    const hour = new Date(fecha).getHours();
    if (!slots[sala]) slots[sala] = {};
    if (!slots[sala][date]) slots[sala][date] = [];
    for (let i = 0; i < duracion; i++) {
      slots[sala][date].push(`${hour + i}:00`);
    }
  });
  return slots;
};

const generateTimeOptions = () => {
  const options = [];
  for (let hour = 10; hour < 22; hour += 2) {
    options.push(`${hour}:00`);
  }
  return options;
};

const DateTimePicker = ({ onChange }) => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [selectedTime, setSelectedTime] = useState(null);
  const [selectedRoom, setSelectedRoom] = useState(1);
  const [occupiedSlots, setOccupiedSlots] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchOccupiedSlots().then(setOccupiedSlots);
  }, []);

  const handleDateChange = (date) => {
    setSelectedDate(date);
    setSelectedTime(null);
  };

  const handleTimeChange = (event) => {
    const time = event.target.value;
    setSelectedTime(time);
    if (onChange) {
      onChange({ date: selectedDate, time, room: selectedRoom });
    }
  };

  const handleRoomChange = (event) => {
    setSelectedRoom(Number(event.target.value));
    setSelectedTime(null);
  };

  const handleReservation = async () => {
    if (!selectedTime) return alert("Por favor selecciona un horario.");
    setIsSubmitting(true);

    const reservationData = {
      sala: String(selectedRoom),
      fecha: `${selectedDate.toISOString().split("T")[0]}T${selectedTime}:00`,
      usuario: "pedro3",
      duracion: 2
    };

    try {
      const response = await fetch("http://api.local/reservas/", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(reservationData)
      });
      if (response.ok) {
        alert("Reserva realizada con éxito");
        fetchOccupiedSlots().then(setOccupiedSlots);
      } else {
        alert("Error al realizar la reserva");
      }
    } catch (error) {
      alert("Error en la conexión con el servidor");
    }
    setIsSubmitting(false);
  };

  const dateString = selectedDate.toISOString().split("T")[0];
  const availableTimes = generateTimeOptions().filter(
    (time) => !(occupiedSlots[selectedRoom]?.[dateString] || []).includes(time)
  );

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        handleReservation();
      }}
      className="space-y-6"
    >
      {/* Sala */}
      <div className="div_form">
        <label className="label">Sala:</label>
        <select
          value={selectedRoom}
          onChange={(e) => setSelectedRoom(e.target.value)}        >
          {[1, 2, 3, 4].map((room) => (
            <option key={room} value={room}>{`Sala ${room}`}</option>
          ))}
        </select>
      </div>

      {/* Fecha */}
      <div className="div_form">
        <label className="label">Fecha:</label>
        <DatePicker
          selected={selectedDate}
          onChange={(date) => setSelectedDate(date)}
          minDate={new Date()}
          dateFormat="yyyy-MM-dd"
        />
      </div>

      {/* Hora */}
      <div className="div_form">
        <label className="label">Hora:</label>
        <select
          value={selectedTime}
          onChange={(e) => setSelectedTime(e.target.value)}
        >
          <option value="">Selecciona un horario</option>
          {availableTimes.map((time) => (
            <option key={time} value={time}>{time}</option>
          ))}
        </select>
      </div>

      {/* Botón */}
      <div className="flex justify-center pt-2">
        <button
          type="submit"
          disabled={isSubmitting}
        >
          {isSubmitting ? "Reservando..." : "Reservar"}
        </button>
      </div>
    </form>
  );
};

export default DateTimePicker;
