package org.example.devsync4.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.example.devsync4.entities.Task;

import java.util.List;

public class TaskRepository {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("myJPAUnit");
    //private final EntityManagerFactory emf = jakarta.persistence.Persistence.createEntityManagerFactory("myJPAUnit");


    public List<Task> findAll() {
        EntityManager em = emf.createEntityManager();
        return em.createQuery("SELECT t FROM Task t", Task.class).getResultList();
    }

    public Task findById(Long id) {
        EntityManager em = emf.createEntityManager();
        return em.find(Task.class, id);
    }

    public void save(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(task);
        em.getTransaction().commit();
        em.close();
    }

    public void update(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(task);
        em.getTransaction().commit();
        em.close();
    }

    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Task task = em.find(Task.class, id);
        if (task != null) {
            em.remove(task);
        }
        em.getTransaction().commit();
        em.close();
    }

}
