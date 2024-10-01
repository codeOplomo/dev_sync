package org.example.devsync4.repositories;


import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import org.example.devsync4.entities.User;
import org.example.devsync4.entities.enumerations.Role;

import java.util.List;

public class UserRepository {

    private final EntityManagerFactory entityManagerFactory = jakarta.persistence.Persistence.createEntityManagerFactory("myJPAUnit");

    public void save(User user) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        transaction.begin();
        entityManager.persist(user);
        transaction.commit();
        entityManager.close();
    }


    public List<User> findAll() {
        EntityManager em = entityManagerFactory.createEntityManager();
        em.getTransaction().begin();
        List<User> users = em.createQuery("SELECT c FROM User c ORDER BY c.id DESC", User.class).getResultList();
        em.close();
        return users;
    }

    public User findById(Long id) {
        EntityManager em = entityManagerFactory.createEntityManager();
        em.getTransaction().begin();
        User user = em.find(User.class, id);
        em.close();
        return user;
    }

    public void update(User user) {
        EntityManager em = entityManagerFactory.createEntityManager();
        em.getTransaction().begin();
        em.merge(user);
        em.getTransaction().commit();
        em.close();
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
