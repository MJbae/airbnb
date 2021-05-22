package mj.airbnb.web;

import mj.airbnb.domain.reservation.Reservation;
import mj.airbnb.service.AccommodationService;
import mj.airbnb.service.ReservationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {

    private ReservationService reservationService;
    private final Logger logger = LoggerFactory.getLogger(AccommodationController.class);

    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    @GetMapping("/{id}")
    public Reservation viewReservation(@PathVariable Long id) {
        return reservationService.findById(id);
    }
}
