package org.example.devsync4.ejb;

import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import org.example.devsync4.entities.User;
import org.example.devsync4.services.UserService;

import java.time.LocalDateTime;
import java.util.List;

@Singleton
@Startup // Ensures that the bean starts with the application
public class TokenResetScheduler {


    private final UserService userService;

    public TokenResetScheduler() {
        this.userService = new UserService();
    }

    // Daily reset at midnight for all users
    @Schedule(hour = "0", minute = "0", second = "0", persistent = true)
    public void resetDailyTokens() {
        List<User> users = userService.findAll();
        for (User user : users) {
            user.setDailyTokens(2);
            user.setLastDailyReset(LocalDateTime.now());
            userService.update(user);
        }
    }

    // Monthly reset at midnight on the first day of the month
    @Schedule(dayOfMonth = "1", hour = "0", minute = "0", second = "0", persistent = false)
    public void resetMonthlyTokens() {
        List<User> users = userService.findAll();
        for (User user : users) {
            user.setMonthlyToken(1);
            user.setLastMonthlyReset(LocalDateTime.now());
            userService.update(user);
        }
    }
}
