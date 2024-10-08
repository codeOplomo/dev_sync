package org.example.devsync4.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.example.devsync4.entities.Tag;

import java.util.List;

public class TagRepository {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("myJPAUnit");

    public List<Tag> findByIds(List<Long> ids) {
        EntityManager em = emf.createEntityManager();
        List<Tag> tags = em.createQuery("SELECT t FROM Tag t WHERE t.id IN :ids", Tag.class)
                .setParameter("ids", ids)
                .getResultList();
        em.close();
        return tags;
    }

    // Find all Tags
    public List<Tag> findAll() {
        EntityManager em = emf.createEntityManager();
        List<Tag> tags = em.createQuery("SELECT t FROM Tag t", Tag.class).getResultList();
        em.close();
        return tags;
    }

    // Find a Tag by its ID
    public Tag findById(Long id) {
        EntityManager em = emf.createEntityManager();
        Tag tag = em.find(Tag.class, id);
        em.close();
        return tag;
    }

    // Save a new Tag
    public void save(Tag tag) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(tag);
        em.getTransaction().commit();
        em.close();
    }

    // Update an existing Tag
    public void update(Tag tag) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(tag);
        em.getTransaction().commit();
        em.close();
    }

    // Delete a Tag by its ID
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Tag tag = em.find(Tag.class, id);
        if (tag != null) {
            em.remove(tag);
        }
        em.getTransaction().commit();
        em.close();
    }
}