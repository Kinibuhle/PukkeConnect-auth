import prisma from "../../config/prismaClient.js";

// Create/Update RSVP (upsert)
export const upsertRsvp = async (req, res) => {
  try {
    const { status } = req.body;
    const { event_id } = req.params;
    const studentId = req.user.id; // comes from auth middleware

    const rsvp = await prisma.eventRsvp.upsert({
      where: {
        eventId_studentId: {
          eventId: Number(event_id),
          studentId,
        },
      },
      update: { status },
      create: { status, eventId: Number(event_id), studentId },
    });

    res.json(rsvp);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Cancel RSVP
export const deleteRsvp = async (req, res) => {
  try {
    const { event_id } = req.params;
    const studentId = req.user.id;

    await prisma.eventRsvp.delete({
      where: {
        eventId_studentId: {
          eventId: Number(event_id),
          studentId,
        },
      },
    });

    res.json({ message: "RSVP cancelled" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// List RSVPs for an event (admin only)
export const listRsvps = async (req, res) => {
  try {
    const { event_id } = req.params;

    const rsvps = await prisma.eventRsvp.findMany({
      where: { eventId: Number(event_id) },
      include: { student: true },
    });

    res.json(rsvps);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
