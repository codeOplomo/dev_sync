package org.example.devsync4.repositories;


import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;

import java.util.List;
import java.util.Optional;

public class UserRepository {

    private final EntityManagerFactory entityManagerFactory = jakarta.persistence.Persistence.createEntityManagerFactory("myJPAUnit");

    public Optional<User> findById(Long id) {
        EntityManager em = entityManagerFactory.createEntityManager();
        User user = null;
        try {
            em.getTransaction().begin();
            user = em.find(User.class, id); // Find the user by ID
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback(); // Handle transaction rollback if needed
            throw e;
        } finally {
            em.close();
        }

        return Optional.ofNullable(user); // Return the user wrapped in an Optional
    }


    public Optional<User> findByEmail(String email) {
        EntityManager em = entityManagerFactory.createEntityManager();
        User user = null;
        try {
            em.getTransaction().begin();
            user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
            em.getTransaction().commit();
        } catch (Exception e) {
            // Optionally log the exception or handle it accordingly
            e.printStackTrace(); // Or use a logger
        } finally {
            em.close();
        }
        return Optional.ofNullable(user); // Wrap in Optional
    }

    public List<User> findByRole(Role role) {
        EntityManager em = entityManagerFactory.createEntityManager(); // Create EntityManager
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.role = :role", User.class)
                    .setParameter("role", role)
                    .getResultList();
        } finally {
            em.close();
        }
    }


    public User save(User user) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(user);
            transaction.commit();
        } catch (Exception e) {
            transaction.rollback();
            throw e;
        } finally {
            entityManager.close();
        }
        return user;
    }



    public List<User> findAll() {
        EntityManager em = entityManagerFactory.createEntityManager();
        em.getTransaction().begin();
        List<User> users = em.createQuery("SELECT c FROM User c ORDER BY c.id DESC", User.class).getResultList();
        em.close();
        return users;
    }


    public User update(User user) {
        EntityManager em = entityManagerFactory.createEntityManager();
        User updatedUser = null;
        try {
            em.getTransaction().begin();
            updatedUser = em.merge(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
        return updatedUser;
    }


    public void delete(Long id) {
        EntityManager em = entityManagerFactory.createEntityManager();
        em.getTransaction().begin();
        User user = em.find(User.class, id);
        em.remove(user);
        em.getTransaction().commit();
        em.close();
    }


}
